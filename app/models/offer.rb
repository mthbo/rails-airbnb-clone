class Offer < ApplicationRecord
  include AlgoliaSearch

  belongs_to :advisor, class_name: 'User'
  has_many :deals, dependent: :nullify
  has_many :pinned_offers, dependent: :destroy
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  enum status: [ :active, :inactive, :archived ]
  enum pricing: [ :free, :priced ]

  validates :description, presence: { message: "The offer must have a title" }, length: { minimum: 10, message: "The offer title is too short, please tell a little more!" }
  validates :description, presence: { message: "The offer must have a description" }, length: { minimum: 50, message: "The offer description is too short, please tell a little more!" }
  validates :languages, presence: { message: "At least one language must me selected" } , length: { in: 1..5 }
  validates :means, presence: { message: "At least one mean of communication must me selected" }

  algoliasearch per_environment: true do
    attribute :title, :description, :status, :pricing, :deals_closed_count, :global_rating, :min_amount, :median_amount, :max_amount
    attribute :languages do
      languages.map { |language| { name: language.name, flag: language.flag } }
    end
    attribute :means do
      means.map { |mean| { name: mean.name, picto: mean.picto } }
    end
    attribute :advisor do
      { name: advisor.name_anonymous, grade: advisor.grade, age: advisor.age, address: advisor.address_short, facebook_picture_url: advisor.facebook_picture_url, photo_path: (advisor.photo.path if advisor.photo) }
    end
    searchableAttributes ['unordered(title)', 'unordered(description)']
    customRanking ['desc(deals_closed_count)', 'desc(global_rating)', 'asc(median_amount)']
    attributesForFaceting [:languages, :means, :deals_closed_count, :global_rating, :min_amount, :median_amount, :max_amount]
    hitsPerPage 10
    removeWordsIfNoResults 'allOptional'
  end

  # def self.search(search)
  #   if search.present?
  #     where(status: :active).where("title ILIKE ?", "%#{search}%") + where(status: :active).where("description ILIKE ?", "%#{search}%")
  #   else
  #     where(status: :active)
  #   end
  # end


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

  def pinned(client)
    pinned_offers.find_by(client: client)
  end



  # Deal stats

  def pin_count
    pinned_offers.count
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


end
