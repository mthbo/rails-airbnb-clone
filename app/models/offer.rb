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

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 30 }
  validates :languages, presence: true, length: { maximum: 5 }
  validates :means, presence: true

  include AlgoliaSearch

  I18n.available_locales.each do |locale|
    algoliasearch index_name: "Offer_#{locale}", per_environment: true, if: :active? do
      attribute :title, :description, :summary, :deals_closed_count, :satisfaction
      attribute :median_amount do
        min_amount.nil? ? 0 : median_amount / 100
      end
      attribute :created_at_i do
        created_at.to_i
      end
      attribute :deals_closed_view do
        deals_closed_view(locale)
      end
      attribute :satisfaction_view do
        satisfaction_view(locale)
      end
      attribute :amounts_view do
        amounts_view(locale)
      end
      attribute :languages do
        languages.map { |language| {flag: language.flag_img, label: language.name_illustrated(locale)} }
      end
      attribute :means do
        means.map { |mean| {picto: mean.picto, label: mean.name_illustrated(locale)} }
      end
      attribute :advisor do
        { name: advisor.name_anonymous, avatar_img: advisor.avatar_img, grade_and_age: advisor.grade_and_age(locale), address: advisor.address_short(locale) }
      end
      searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
      customRanking ['desc(deals_closed_count)', 'desc(satisfaction)', 'asc(median_amount)', 'desc(created_at_i)']
      attributesForFaceting [:languages, :means, :median_amount]
      separatorsToIndex '+#$€'
      removeWordsIfNoResults 'allOptional'
      ignorePlurals true

      add_replica "Offer_#{locale}_price_asc", per_environment: true, inherit: true do
        searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
        customRanking ['asc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
        attributesForFaceting [:languages, :means, :median_amount]
        separatorsToIndex '+#$€'
        removeWordsIfNoResults 'allOptional'
        ignorePlurals true
      end

      add_replica "Offer_#{locale}_price_desc", per_environment: true, inherit: true do
        searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
        customRanking ['desc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
        attributesForFaceting [:languages, :means, :median_amount]
        separatorsToIndex '+#$€'
        removeWordsIfNoResults 'allOptional'
        ignorePlurals true
      end

      add_replica "Offer_#{locale}_satisfaction_desc", per_environment: true, inherit: true do
        searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
        customRanking ['desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)', 'desc(created_at_i)']
        attributesForFaceting [:languages, :means, :median_amount]
        separatorsToIndex '+#$€'
        removeWordsIfNoResults 'allOptional'
        ignorePlurals true
      end

      add_replica "Offer_#{locale}_created_at_desc", per_environment: true, inherit: true do
        searchableAttributes ['unordered(title)', 'unordered(description)', 'unordered(summary)']
        customRanking ['desc(created_at_i)', 'desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)']
        attributesForFaceting [:languages, :means, :median_amount]
        separatorsToIndex '+#$€'
        removeWordsIfNoResults 'allOptional'
        ignorePlurals true
      end
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

  def min_amount
    amount = deals_closed.minimum(:amount_cents).to_i + deals_closed.minimum(:fees_cents).to_i
    amount.zero? ? nil : amount
  end

  def max_amount
    amount = deals_closed.maximum(:amount_cents).to_i + deals_closed.maximum(:fees_cents).to_i
    amount.zero? ? nil : amount
  end

  def median_amount
    if deals_closed.present?
      amounts = []
      deals_closed.each { |deal| amounts << deal.total_amount_cents unless deal.total_amount_cents.nil? }
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

  def amounts_view(locale)
    html = ""
    if free?
      html << "<strong>#{I18n.t('offers.amounts.free', locale: locale)}</strong>"
    elsif median_amount.nil?
      html << "<span class='medium-gray'>#{I18n.t('offers.amounts.no_history', locale: locale)}</span>"
    else
      html << "<span class='medium-gray'>#{ I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(min_amount_money), currency: min_amount_money.currency.symbol, locale: locale )} &mdash; </span>"
      html << "<strong>#{I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(median_amount_money), currency: median_amount_money.currency.symbol, locale: locale )}</strong>"
      html << "<span class='medium-gray'> &mdash; #{I18n.t('money', amount: ActionController::Base.helpers.money_without_cents(max_amount_money), currency: max_amount_money.currency.symbol, locale: locale )}</span>"
    end
    html
  end

end
