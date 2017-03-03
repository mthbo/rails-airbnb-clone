class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals, dependent: :nullify
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  acts_as_votable

  enum status: [ :active, :inactive, :archived ]
  enum pricing: [ :free, :priced ]

  validates :description, presence: { message: "The offer must have a title" }, length: { minimum: 10, message: "The offer title is too short, please tell a little more!" }
  validates :description, presence: { message: "The offer must have a description" }, length: { minimum: 50, message: "The offer description is too short, please tell a little more!" }
  validates :languages, presence: { message: "At least one language must me selected" } , length: { in: 1..5 }
  validates :means, presence: { message: "At least one mean of communication must me selected" }

  include AlgoliaSearch

  algoliasearch per_environment: true, if: :active? do
    attribute :title, :description, :summary, :deals_closed_view, :deals_closed_count, :global_rating_view, :global_rating, :amounts_view
    attribute :median_amount do
      min_amount.nil? ? 0 : median_amount / 100
    end
    attribute :created_at_i do
      created_at.to_i
    end
    attribute :languages do
      languages.map { |language| { label: language.name_illustrated, flag: language.flag_img } }
    end
    attribute :means do
      means.map { |mean| { label: mean.name_illustrated, picto: mean.picto } }
    end
    attribute :advisor do
      { name: advisor.name_anonymous, grade_and_age: advisor.grade_and_age, address: advisor.address_short, avatar_img: advisor.avatar_img }
    end
    searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
    customRanking ['desc(deals_closed_count)', 'desc(global_rating)', 'asc(median_amount)', 'desc(created_at_i)']
    attributesForFaceting [:languages, :means, :global_rating, :median_amount]
    separatorsToIndex '+#$€'
    removeWordsIfNoResults 'allOptional'
    ignorePlurals true
    hitsPerPage 10
    add_replica 'Offer_price_asc', inherit: true, per_environment: true do
      customRanking ['asc(median_amount)', 'desc(deals_closed_count)', 'desc(global_rating)', 'desc(created_at_i)']
      typoTolerance 'min'
    end
    add_replica 'Offer_price_desc', inherit: true, per_environment: true do
      customRanking ['desc(median_amount)', 'desc(deals_closed_count)', 'desc(global_rating)', 'desc(created_at_i)']
      typoTolerance 'min'
    end
  end


  # Deals for an offer

  def deals_request
    deals.where(status: :request)
  end

  def deals_proposition
    deals.where(status: :proposition).or(deals.where(status: :proposition_declined))
  end

  def deals_pending
    deals_request.or(deals_proposition)
  end

  def deals_open
    deals.where(status: :open).or(deals.where(status: :open_expired))
  end

  def deals_ongoing
    deals_pending.or(deals_open)
  end

  def deals_closed
    deals.where(status: :closed)
  end

  def deals_reviewed
    deals.where.not(client_review_at: nil).order(client_review_at: :desc)
  end


  # Deal for an offer with a specific client

  def pending_deal(client)
    deals_pending.find_by(client: client)
  end

  def open_deal(client)
    deals_open.find_by(client: client)
  end

  def ongoing_deal(client)
    deals_ongoing.find_by(client: client)
  end


  # Deal stats

  def pin_count
    get_likes.count
  end

  def deals_pending_count
    deals_pending.count
  end

  def deals_open_count
    deals_open.count
  end

  def deals_ongoing_count
    deals_ongoing.count
  end

  def deals_closed_count
    deals_closed.count
  end


  # Rating stat

  def global_rating
    if deals_reviewed.present?
      sum = 0
      deals_reviewed.each { |deal| sum += deal.client_global_rating }
      sum.fdiv(deals_reviewed.count)
    end
  end


  # Pricing stat

  def min_amount
    deals_closed.minimum(:amount_cents)
  end

  def max_amount
    deals_closed.maximum(:amount_cents)
  end

  def median_amount
    if deals_closed.present?
      amounts = []
      deals_closed.each { |deal| amounts << deal.amount_cents unless deal.amount_cents.nil? }
      amounts.sort!
      len = amounts.length
      (amounts[(len - 1) / 2] + amounts[len / 2]) / 2 unless len.zero?
    end
  end

  def min_amount_money
    Money.new(min_amount) unless min_amount.nil?
  end

  def max_amount_money
    Money.new(max_amount) unless max_amount.nil?
  end

  def median_amount_money
    Money.new(median_amount) unless median_amount.nil?
  end


  # For Algolia

  def summary
    description[0..250]
  end

  def deals_closed_view
    "<strong>#{deals_closed_count}</strong> #{'session'.pluralize(deals_closed_count)}"
  end

  def global_rating_view
    html = ""
    unless global_rating.nil?
      html << "<i class='fa fa-star yellow' aria-hidden='true'></i>" * global_rating.round
      html << "<i class='fa fa-star-o medium-gray' aria-hidden='true'></i>" * (5 - global_rating.round)
      html << "<span>&nbsp;&nbsp;<strong>#{(global_rating.fdiv(5) * 100).to_i} %</strong>  happy</span>"
    else
      html << "<i class='fa fa-star-o medium-gray' aria-hidden='true'></i>" * 5
      html << "<span class='medium-gray'>&nbsp;&nbsp; not rated yet</span>"
    end
    html
  end

  def amounts_view
    html = ""
    if free?
      html << "<strong>FREE</strong>"
    elsif median_amount.nil?
      html << "<span class='medium-gray'>No price yet</span>"
    else
      html << "<span class='medium-gray'>#{ActionController::Base.helpers.money_without_cents_and_with_symbol(min_amount_money)} &mdash; </span>"
      html << "<strong>#{ActionController::Base.helpers.money_without_cents_and_with_symbol(median_amount_money)}</strong>"
      html << "<span class='medium-gray'> &mdash; #{ActionController::Base.helpers.money_without_cents_and_with_symbol(max_amount_money)}</span>"
    end
    html
  end

end
