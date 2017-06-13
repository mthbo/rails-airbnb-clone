class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  acts_as_voter

  enum pricing: [ :no_pricing, :pricing_pending, :pricing_enabled, :pricing_disabled ]
  enum bank_status: [:no_bank, :bank_valid, :bank_invalid]
  enum legal_type: [ :individual, :company ]

  has_many :offers, foreign_key: 'advisor_id', dependent: :destroy
  has_many :client_deals, foreign_key: 'client_id', class_name: 'Deal', dependent: :nullify
  has_many :advisor_deals, through: :offers, source: :deals
  has_many :messages, dependent: :nullify
  has_many :additional_owners, dependent: :destroy

  has_attachment :photo, accept: [:jpg, :png, :gif]

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  phony_normalize :phone_number, default_country_code: 'FR'
  validates :phone_number, phony_plausible: true

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validate :birth_date_must_be_valid

  validates :country_code, presence: true, allow_blank: false, if: :country_required?
  validate :country_must_be_valid

  validates :birth_date, presence: true, if: :legal_details_required?
  validates :address, presence: true, if: :legal_details_required?
  validates :zip_code, presence: true, if: :legal_details_required?
  validates :city, presence: true, if: :legal_details_required?
  validates :identity_document_name, presence: true, if: :legal_details_required?

  validates :business_name, presence: true, if: :legal_details_company_required?
  validates :business_tax_id, presence: true, if: :legal_details_company_required?
  validates :personal_address, presence: true, if: :legal_details_company_required?
  validates :personal_city, presence: true, if: :legal_details_company_required?
  validates :personal_zip_code, presence: true, if: :legal_details_company_required?

  validates :bank_name, presence: true, if: :bank_invalid?
  validates :bank_last4, presence: true, if: :bank_invalid?

  STRIPE_ALLOWED_COUNTRIES = []

  # User information

  def first_name=(s)
    write_attribute(:first_name, s.to_s.capitalize)
  end

  def last_name=(s)
    write_attribute(:last_name, s.to_s.capitalize)
  end

  def name_anonymous
    "#{first_name} #{last_name.first}."
  end

  def age
    if birth_date.present?
      today = DateTime.current.in_time_zone
      d = DateTime.new(today.year, birth_date.month, birth_date.day).in_time_zone
      age = d.year - birth_date.year - (d > today ? 1 : 0)
    end
  end

  def city=(s)
    write_attribute(:city, s.to_s.capitalize)
  end

  def country(locale=I18n.locale)
    if country_code.present?
      country_data = ISO3166::Country[country_code]
      country_data.translations[locale.to_s] || country_data.name
    end
  end

  def address_short(locale=I18n.locale)
    if city.present? && country_code.present?
      "#{city}, #{country(locale)}"
    elsif city.present? && country_code.blank?
      "#{city}"
    elsif city.blank? && country_code.present?
      "#{country(locale)}"
    else
      " - "
    end
  end

  def currency
    Money::Currency.find(self.currency_code) ? Money::Currency.find(self.currency_code) : Money.default_currency
  end

  def self.stripe_allowed_countries(locale=I18n.locale)
    STRIPE_ALLOWED_COUNTRIES.map do |country_code|
      country_data = ISO3166::Country[country_code]
      country_data.translations[locale.to_s] || country_data.name
    end
  end

  def pricing_available?
    STRIPE_ALLOWED_COUNTRIES.include?(country_code)
  end

  def country_required?
    !self.no_pricing?
  end

  def legal_details_required?
    !self.no_pricing? && !self.pricing_pending?
  end

  def legal_details_company_required?
    legal_details_required? && self.company?
  end

  def disabled_reason_category
    case self.disabled_reason
    when 'rejected.fraud' then 'rejected'
    when 'rejected.terms_of_service' then 'rejected'
    when 'rejected.listed' then 'rejected'
    when 'rejected.other' then 'rejected'
    when 'fields_needed' then 'fields_needed'
    when 'listed' then 'pending'
    when 'under_review' then 'pending'
    when 'other' then 'pending'
    when '' then 'pending'
    when nil then 'pending'
    end
  end

  def avatar_img
    if photo.present?
      ActionController::Base.helpers.cl_image_tag(photo.path, width: 100, height: 100, crop: :thumb, gravity: :face, class: "avatar-medium bg-light-gray").to_s
    else
      url = facebook_picture_url || "avatar.png"
      ActionController::Base.helpers.image_tag(url, class: "avatar-medium bg-light-gray").to_s
    end
  end

  def grade(locale=I18n.locale)
    if advisor_deals_closed_count > 20
      I18n.t('users.info.grade_4', locale: locale)
    elsif advisor_deals_closed_count > 10
      I18n.t('users.info.grade_3', locale: locale)
    elsif advisor_deals_closed_count > 3
      I18n.t('users.info.grade_2', locale: locale)
    else
      I18n.t('users.info.grade_1', locale: locale)
    end
  end

  def grade_and_age(locale=I18n.locale)
    html = grade(locale)
    if age.present?
      html << "&nbsp; | &nbsp;#{age} #{I18n.t('users.info.age', locale: locale)}"
    end
    html
  end


  # User offers

  def offers_active
    offers.where(status: :active).order(updated_at: :desc)
  end

  def offers_inactive
    offers.where(status: :inactive).order(updated_at: :desc)
  end

  def offers_published
    offers.where.not(status: :archived).order(updated_at: :desc)
  end

  def offers_priced
    offers_published.where(pricing: :priced)
  end


  # User deals as advisor

  def advisor_deals_request
    advisor_deals.where(status: :request).order(updated_at: :desc)
  end

  def advisor_deals_proposition
    advisor_deals.where(status: :proposition).or(advisor_deals.where(status: :proposition_declined)).order(updated_at: :desc)
  end

  def advisor_deals_pending
    advisor_deals_request.or(advisor_deals_proposition)
  end

  def advisor_deals_open
    advisor_deals.where(status: :opened).or(advisor_deals.where(status: :open_expired)).order(updated_at: :desc)
  end

  def advisor_deals_ongoing
    advisor_deals_pending.or(advisor_deals_open)
  end

  def advisor_deals_closed
    advisor_deals.where(status: :closed).order(updated_at: :desc)
  end

  def advisor_deals_closed_recent
    advisor_deals_closed.where("closed_at > ?", 1.month.ago)
  end

  def advisor_deals_current
    advisor_deals_ongoing.or(advisor_deals_closed_recent)
  end

  def advisor_deals_closed_old
    advisor_deals_closed.where("closed_at <= ?", 1.month.ago)
  end

  def advisor_deals_cancelled
    advisor_deals.where(status: :cancelled).order(updated_at: :desc)
  end

  def advisor_deals_reviewed
    advisor_deals.where.not(client_review_at: nil).order(client_review_at: :desc)
  end

  def advisor_deals_payout_failed
    advisor_deals_closed.where(payment_state: :payout_failed)
  end


  # User deals as client

  def client_deals_request
    client_deals.where(status: :request).order(updated_at: :desc)
  end

  def client_deals_proposition
    client_deals.where(status: :proposition).or(client_deals.where(status: :proposition_declined)).order(updated_at: :desc)
  end

  def client_deals_pending
    client_deals_request.or(client_deals_proposition)
  end

  def client_deals_open
    client_deals.where(status: :opened).or(client_deals.where(status: :open_expired)).order(updated_at: :desc)
  end

  def client_deals_ongoing
    client_deals_pending.or(client_deals_open)
  end

  def client_deals_closed
    client_deals.where(status: :closed).order(updated_at: :desc)
  end

  def client_deals_closed_recent
    client_deals_closed.where("closed_at > ?", 1.month.ago)
  end

  def client_deals_current
    client_deals_ongoing.or(client_deals_closed_recent)
  end

  def client_deals_closed_old
    client_deals_closed.where("closed_at <= ?", 1.month.ago)
  end

  def client_deals_cancelled
    client_deals.where(status: :cancelled).order(updated_at: :desc)
  end

  def client_deals_reviewed
    client_deals.where.not(advisor_review_at: nil).order(advisor_review_at: :desc)
  end


  # All user deals

  def deals
    deals_as_advisor = Deal.where(offer: self.offers)
    deals_as_client = Deal.where(client: self)
    deals_as_advisor.or(deals_as_client)
  end

  def deals_request
    deals.where(status: :request).order(updated_at: :desc)
  end

  def deals_proposition
    deals.where(status: :proposition).or(deals.where(status: :proposition_declined)).order(updated_at: :desc)
  end

  def deals_pending
    deals_request.or(deals_proposition)
  end

  def deals_open
    deals.where(status: :opened).or(deals.where(status: :open_expired)).order(updated_at: :desc)
  end

  def deals_ongoing
    deals_pending.or(deals_open)
  end

  def deals_closed
    deals.where(status: :closed).order(updated_at: :desc)
  end

  def deals_closed_recent
    deals_closed.where("closed_at > ?", 1.month.ago)
  end

  def deals_current
    deals_ongoing.or(deals_closed_recent)
  end

  def deals_closed_old
    deals_closed.where("closed_at <= ?", 1.month.ago)
  end

  def deals_cancelled
    deals.where(status: :cancelled).order(updated_at: :desc)
  end

  def deals_reviewed
    deals_as_advisor = Deal.where(offer: self.offers).where.not(client_review_at: nil)
    deals_as_client = Deal.where(client: self).where.not(advisor_review_at: nil)
    # TODO: Try to write a join query to order by dates
    deals_as_advisor.or(deals_as_client).order(client_review_at: :desc)
  end


  # Notifications

  def deals_current_notifications
    notifications = 0
    client_deals_current.each { |deal| notifications += deal.client_notifications }
    advisor_deals_current.each { |deal| notifications += deal.advisor_notifications }
    notifications
  end

  def deals_past_notifications
    notifications = 0
    client_deals_closed_old.each { |deal| notifications += deal.client_notifications }
    advisor_deals_closed_old.each { |deal| notifications += deal.advisor_notifications }
    notifications
  end

  def deals_cancelled_notifications
    notifications = 0
    client_deals_cancelled.each { |deal| notifications += deal.client_notifications }
    advisor_deals_cancelled.each { |deal| notifications += deal.advisor_notifications }
    notifications
  end

  def deals_all_notifications
    deals_current_notifications + deals_past_notifications + deals_cancelled_notifications
  end


  # User stat

  def offers_active_count
    offers_active.count
  end

  def offers_inactive_count
    offers_inactive.count
  end

  def offers_priced_count
    offers_priced.count
  end

  def client_deals_pending_count
    client_deals_pending.count
  end

  def advisor_deals_pending_count
    advisor_deals_pending.count
  end

  def client_deals_open_count
    client_deals_open.count
  end

  def advisor_deals_open_count
    advisor_deals_open.count
  end

  def client_deals_ongoing_count
    client_deals_ongoing.count
  end

  def advisor_deals_ongoing_count
    advisor_deals_ongoing.count
  end

  def client_deals_closed_count
    client_deals_closed.count
  end

  def advisor_deals_closed_count
    advisor_deals_closed.count
  end


  # Legal type option I18n names

  def self.translated_legal_types
    legal_types.map do |legal_type, i|
      [I18n.t("activerecord.attributes.user.legal_types.#{legal_type}"), legal_type]
    end
  end


  # Facebook oauth

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    facebook_locale = auth.extra.raw_info.locale.split('_').first if auth.extra.raw_info.locale
    user_params[:locale] = I18n.available_locales.include?(facebook_locale.to_sym) ? facebook_locale : I18n.default_locale.to_s

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first
    if user
      user.skip_confirmation!
      user.update(user_params)
    else
      user = User.new(user_params)
      user.skip_confirmation!
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    I18n.locale = user.locale
    return user
  end


  private

  # Validations

  def birth_date_must_be_valid
    errors.add(:birth_date) if
      birth_date.present? && (birth_date > DateTime.current.in_time_zone || birth_date < 130.years.ago)
  end

  def country_must_be_valid
    errors.add(:country_code) if
      legal_details_required? && !pricing_available?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

end
