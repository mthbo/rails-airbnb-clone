class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals, dependent: :nullify
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  acts_as_votable

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
    attribute :title, :slug, :description, :summary, :created_at_i, :deals_closed_count, :satisfaction
    attribute :median_amount do
      median_amount.nil? ? 0 : median_amount.to_i
    end
    I18n.available_locales.each do |locale|
      attribute "deals_closed_view_#{locale}".to_sym do
        deals_closed_view(locale)
      end
      attribute "satisfaction_view_#{locale}".to_sym do
        satisfaction_view(locale)
      end
      currency_codes = ['EUR', 'USD']
      currency_codes.each do |currency_code|
        attribute "amounts_view_#{currency_code}_#{locale}".to_sym do
          amounts_view(locale, currency_code)
        end
      end
    end
    attribute :languages do
      languages.map do |language|
        language_attributes = {flag: language.flag_img}
        I18n.available_locales.each { |locale| language_attributes["label_#{locale}".to_sym] = language.name_illustrated(locale) }
        language_attributes
      end
    end
    attribute :means do
      means.map do |mean|
        mean_attributes = {picto: mean.picto}
        I18n.available_locales.each { |locale| mean_attributes["label_#{locale}".to_sym] = mean.name_illustrated(locale) }
        mean_attributes
      end
    end
    attribute :advisor do
      advisor_attributes = { name: advisor.name_anonymous, avatar_img: advisor.avatar_img }
      I18n.available_locales.each do |locale|
        advisor_attributes["grade_and_age_#{locale}".to_sym] = advisor.grade_and_age(locale)
        advisor_attributes["address_#{locale}".to_sym] = advisor.address_short(locale)
      end
      advisor_attributes
    end
    searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
    customRanking ['desc(deals_closed_count)', 'desc(satisfaction)', 'asc(median_amount)', 'desc(created_at_i)']
    attributesForFaceting [:languages, :means, :median_amount]
    separatorsToIndex '+#$€'
    removeWordsIfNoResults 'allOptional'
    ignorePlurals true

    add_replica "#{ENV['PIPELINE_ENV']}_offers_price_asc", inherit: true do
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['asc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
      attributesForFaceting [:languages, :means, :median_amount]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_price_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
      attributesForFaceting [:languages, :means, :median_amount]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_satisfaction_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)', 'desc(created_at_i)']
      attributesForFaceting [:languages, :means, :median_amount]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end

    add_replica "#{ENV['PIPELINE_ENV']}_offers_created_at_desc", inherit: true do
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(created_at_i)', 'desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)']
      attributesForFaceting [:languages, :means, :median_amount]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true
    end
  end

  def self.sample(x)
    offset = rand(Offer.where(status: :active).count - x + 1)
    Offer.where(status: :active).offset(offset).limit(x)
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


  # Rating stat

  def satisfaction
    if deals_reviewed.present?
      sum = 0
      deals_reviewed.each { |deal| sum += deal.client_global_rating }
      sum.fdiv(deals_reviewed.count)
    end
  end


  # Pricing stat

  def min_amount_cents
    deals_closed.where.not(amount_cents: nil).map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.min
  end

  def max_amount_cents
    deals_closed.where.not(amount_cents: nil).map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.max
  end

  def median_amount_cents
    amounts = deals_closed.where.not(amount_cents: nil).map { |deal| deal.amount.exchange_to(Money.default_currency).cents }.sort
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

  def meta_description
    description[0..160]
  end

  private

  # For Algolia

  def summary
    description[0..250]
  end

  def deals_closed_view(locale)
    "<span class='#{deals_closed_count > 0 ? "blank-nowrap" : "medium-gray"}'>#{I18n.t('offers.deals_count.sessions_html', count: deals_closed_count, locale: locale)}</span>"
  end

  def satisfaction_view(locale)
    html = ""
    unless satisfaction.nil?
      html << "<i class='fa fa-star yellow' aria-hidden='true'></i>&nbsp;" * satisfaction.round
      html << "<i class='fa fa-star-o medium-gray' aria-hidden='true'></i>&nbsp;" * (5 - satisfaction.round)
      html << "<span>&nbsp;&nbsp;<strong>#{(satisfaction.fdiv(5) * 100).to_i} %</strong> #{I18n.t('offers.satisfaction.happy', locale: locale)}</span>"
    else
      html << "<i class='fa fa-star-o medium-gray' aria-hidden='true'></i>&nbsp;" * 5
      html << "<span class='medium-gray'>&nbsp;&nbsp; #{I18n.t('offers.satisfaction.not_rated', locale: locale)}</span>"
    end
    html
  end

  def amounts_view(locale, currency_code)
    html = ""
    if free? || !self.advisor.pricing_available? || !self.advisor.pricing_enabled?
      html << "<strong>#{I18n.t('offers.amounts.free', locale: locale)}</strong>"
    elsif median_amount_cents.nil?
      html << "<span class='medium-gray'>#{I18n.t('offers.amounts.no_history', locale: locale)}</span>"
    else
      html << "<span class='medium-gray'>#{ I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(min_amount_converted(currency_code)), currency: min_amount_converted(currency_code).symbol, locale: locale )} &mdash; </span>"
      html << "<strong>#{I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(median_amount_converted(currency_code)), currency: median_amount_converted(currency_code).symbol, locale: locale )}</strong>"
      html << "<span class='medium-gray'> &mdash; #{I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(max_amount_converted(currency_code)), currency: max_amount_converted(currency_code).symbol, locale: locale )}</span>"
    end
    html
  end

  def created_at_i
    created_at.to_i
  end

  # Frindly URL

  def slug_candidates
    [
      :title,
      [:title, :created_at_i]
    ]
  end

  def regenerate_slug
    self.slug = nil
    self.save
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end
