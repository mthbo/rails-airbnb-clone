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

  algoliasearch per_environment: true, if: :active? do
    attribute :title, :description, :summary, :deals_closed_count, :satisfaction
    attribute :median_amount do
      min_amount.nil? ? 0 : median_amount / 100
    end
    attribute :created_at_i do
      created_at.to_i
    end
    I18n.available_locales.each do |locale|
      attribute "deals_closed_view_#{locale}".to_sym do
        deals_closed_view(locale)
      end
      attribute "satisfaction_view_#{locale}".to_sym do
        satisfaction_view(locale)
      end
      attribute "amounts_view_#{locale}".to_sym do
        amounts_view(locale)
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
    add_replica 'Offer_price_asc', inherit: true, per_environment: true do
      customRanking ['asc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
    end
    add_replica 'Offer_price_desc', inherit: true, per_environment: true do
      customRanking ['desc(median_amount)', 'desc(deals_closed_count)', 'desc(satisfaction)', 'desc(created_at_i)']
    end
    add_replica 'Offer_satisfaction_desc', inherit: true, per_environment: true do
      customRanking ['desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)', 'desc(created_at_i)']
    end
    add_replica 'Offer_created_at_desc', inherit: true, per_environment: true do
      customRanking ['desc(created_at_i)', 'desc(satisfaction)', 'desc(deals_closed_count)', 'asc(median_amount)']
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
      html << "<span class='medium-gray'>#{I18n.t('offers.amounts.no_price', locale: locale)}</span>"
    else
      html << "<span class='medium-gray'>#{ActionController::Base.helpers.money_without_cents_and_with_symbol(min_amount_money)} &mdash; </span>"
      html << "<strong>#{ActionController::Base.helpers.money_without_cents_and_with_symbol(median_amount_money)}</strong>"
      html << "<span class='medium-gray'> &mdash; #{ActionController::Base.helpers.money_without_cents_and_with_symbol(max_amount_money)}</span>"
    end
    html
  end

end
