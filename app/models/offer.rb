class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals, dependent: :nullify
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  acts_as_votable
  acts_as_taggable_on :topics

  extend FriendlyId
  friendly_id :slug_candidates
  after_create :regenerate_slug

  enum status: [ :active, :inactive, :archived ]
  enum pricing: [ :free, :priced ]

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 30 }
  validates :languages, presence: true, length: { maximum: 5 }
  validates :means, presence: true

  monetize :min_amount_cents, allow_nil: true
  monetize :max_amount_cents, allow_nil: true
  monetize :median_amount_cents, allow_nil: true

  include AlgoliaSearch

  algoliasearch index_name: "#{ENV['PIPELINE_ENV']}_offers", if: :active? do
    attribute :title, :slug, :description, :summary, :created_at_i, :deals_closed_count, :satisfaction, :no_pricing?, :no_price_history?
    attribute :median_amount_cents do
      median_amount_cents.nil? ? 0 : median_amount_cents
    end
    attribute :min_amount_cents do
      min_amount_cents.nil? ? 0 : min_amount_cents
    end
    attribute :max_amount_cents do
      max_amount_cents.nil? ? 0 : max_amount_cents
    end
    attribute :topics do
      topic_list
    end
    attribute :languages do
      languages.map { |language| { flag: language.flag_img } }
    end
    attribute :means do
      means.map { |mean| { picto: mean.picto, info: "#{mean.picto} #{mean.name_formatted}" } }
    end
    attribute :advisor do
      {
        id: advisor.id.to_s,
        name: advisor.name_anonymous,
        avatar_img: advisor.avatar_img,
        grade_img: advisor.grade_img,
        age: advisor.age,
        city: advisor.city.present? ? advisor.city : nil,
        country_code: advisor.country_code.present? ? advisor.country_code : nil
      }
    end
    searchableAttributes ['unordered(title)', 'topics', 'unordered(description)', 'unordered(summary)']
    customRanking ['desc(deals_closed_count)', 'desc(satisfaction)', 'asc(median_amount_cents)', 'desc(created_at_i)']
    attributesForFaceting [:topics, :languages, :means, :median_amount_cents]
    separatorsToIndex '+#$€'
    removeWordsIfNoResults 'allOptional'
    ignorePlurals true

    add_replica "#{ENV['PIPELINE_ENV']}_offers_price_asc", inherit: true do
      searchableAttributes ['unordered(title)', 'topics', 'unordered(description)', 'unordered(summary)']
      customRanking ['asc(median_amount_cents)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
      attributesForFaceting [:topics, :languages, :means, :median_amount_cents]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_price_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'topics', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(median_amount_cents)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
      attributesForFaceting [:topics, :languages, :means, :median_amount_cents]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_satisfaction_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount_cents)', 'desc(created_at_i)']
      attributesForFaceting [:topics, :languages, :means, :median_amount_cents]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_created_at_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'topics', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(created_at_i)', 'desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount_cents)']
      attributesForFaceting [:topics, :languages, :means, :median_amount_cents]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end
  end

  # Description extracts

  def summary
    description[0..250]
  end

  def meta_description
    description[0..160]
  end

  def topic_list_short
    short_list = ""
    topic_list.each do |topic|
      short_list << topic
      break if short_list.length > 50
      short_list << ","
    end
    short_list.split(',')
  end

  # Video call

  def video_call?
    means.include?(Mean.find_by_name("Video call"))
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
    deals.where(status: :opened).or(deals.where(status: :open_expired))
  end

  def deals_ongoing
    deals_pending.or(deals_open)
  end

  def deals_closed
    deals.where(status: :closed)
  end

  def deals_closed_priced
    deals_closed.where.not(amount_cents: nil)
  end

  def deals_reviewed
    deals.where.not(client_review_at: nil).order(client_review_at: :desc)
  end


  # Deal for an offer with a specific client

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

  def deals_closed_priced_count
    deals_closed_priced.count
  end


  # Rating stat

  def satisfaction
    if deals_reviewed.present?
      sum = 0
      deals_reviewed.each { |deal| sum += deal.client_global_rating }
      sum.fdiv(deals_reviewed.count)
    end
  end

  # Pricing option I18n names

  def self.translated_pricings
    icons = [
      "<span class='info-icon'>#{ ActionController::Base.helpers.image_tag('no_amount.svg') }</span>".html_safe,
      "<span class='info-icon'>#{ ActionController::Base.helpers.image_tag('amount.svg') }</span>".html_safe
    ]
    pricings.map do |pricing, i|
      [icons[i] + I18n.t("activerecord.attributes.offer.pricings.#{pricing}"), pricing]
    end
  end

  # Pricing stat

  def no_pricing?
    free? || !self.advisor.pricing_available? || !self.advisor.pricing_enabled?
  end

  def no_price_history?
    deals_closed_priced.blank?
  end

  def min_amount_cents
    deals_closed_priced.map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.min
  end

  def max_amount_cents
    deals_closed_priced.map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.max
  end

  def median_amount_cents
    amounts = deals_closed_priced.map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.sort
    len = amounts.length
    len.zero? ? nil : (amounts[(len - 1) / 2] + amounts[len / 2]) / 2
  end

  def min_amount_converted(currency_code=Money.default_currency.to_s)
    min_amount.exchange_to(currency_code) if min_amount
  end

  def max_amount_converted(currency_code=Money.default_currency.to_s)
    max_amount.exchange_to(currency_code) if max_amount
  end

  def median_amount_converted(currency_code=Money.default_currency.to_s)
    median_amount.exchange_to(currency_code) if median_amount
  end

  private

  def created_at_i
    created_at.to_i
  end

  # Frindly URL

  def slug_candidates
    [:title, [:title, :created_at_i]]
  end

  def regenerate_slug
    self.slug = nil
    self.save
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end
