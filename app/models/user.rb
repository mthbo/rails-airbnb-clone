class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :offers, foreign_key: 'advisor_id', dependent: :destroy
  has_many :client_deals, foreign_key: 'client_id', class_name: 'Deal', dependent: :nullify
  has_many :pinned_offers, foreign_key: 'client_id', dependent: :destroy
  has_many :advisor_deals, through: :offers, source: :deals
  has_many :messages, dependent: :nullify

  has_attachment :photo, accept: [:jpg, :png, :gif]

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :first_name, presence: { message: "You must have a first name" }, length: { minimum: 2 }
  validates :last_name, presence: { message: "You must have a last name" }, length: { minimum: 2 }
  validates :bio, length: { minimum: 50, message: "Your bio is too short, please tell a little more!" }, allow_blank: true

  validate :birth_date_must_be_valid

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
      "#{age} yr"
    end
  end

  def city=(s)
    write_attribute(:city, s.to_s.capitalize)
  end

  def country_name
    if country.present?
      country_data = ISO3166::Country[country]
      country_data.translations[I18n.locale.to_s] || country_data.name
    end
  end

  def address_short
    if city.present? && country.present?
      "#{city}, #{country_name}"
    elsif city.present? && country.blank?
      "#{city}"
    elsif city.blank? && country.present?
      "#{country_name}"
    else
      " - "
    end
  end

  def bio_formatted
    "<p>#{self.bio.gsub(/\r\n/, '<br>')}</p>"
  end

  # User stat

  def grade
    if advisor_deals_closed.count > 20
      "Guide"
    elsif advisor_deals_closed.count > 10
      "Champion"
    elsif advisor_deals_closed.count > 3
      "Advisor"
    else
      "Papoter"
    end
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


  # User sessions as advisor

  def advisor_deals_request
    advisor_deals.where(status: :request)
  end

  def advisor_deals_proposition
    advisor_deals.where(status: :proposition).or(advisor_deals.where(status: :proposition_declined))
  end

  def advisor_deals_pending
    advisor_deals_request.or(advisor_deals_proposition)
  end

  def advisor_deals_open
    advisor_deals.where(status: :open).or(advisor_deals.where(status: :open_expired))
  end

  def advisor_deals_ongoing
    advisor_deals_pending.or(advisor_deals_open)
  end

  def advisor_deals_closed
    advisor_deals.where(status: :closed).order(closed_at: :desc)
  end

  def advisor_deals_reviewed
    advisor_deals.where.not(client_review: nil).order(client_review_at: :desc)
  end


  # User sessions as client

  def client_deals_request
    client_deals.where(status: :request)
  end

  def client_deals_proposition
    client_deals.where(status: :proposition).or(client_deals.where(status: :proposition_declined))
  end

  def client_deals_pending
    client_deals_request.or(client_deals_proposition)
  end

  def client_deals_open
    client_deals.where(status: :open).or(client_deals.where(status: :open_expired))
  end

  def client_deals_ongoing
    client_deals_pending.or(client_deals_open)
  end

  def client_deals_closed
    client_deals.where(status: :closed).order(closed_at: :desc)
  end

  def client_deals_reviewed
    client_deals.where.not(advisor_review: nil).order(advisor_review_at: :desc)
  end


  # All user sessions

  def deals
    deals_as_advisor = Deal.where(offer: self.offers)
    deals_as_client = Deal.where(client: self)
    deals_as_advisor.or(deals_as_client)
  end

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
    deals.where(status: :closed).order(closed_at: :desc)
  end

  def deals_reviewed
    deals_as_advisor = Deal.where(offer: self.offers).where.not(client_review: nil)
    deals_as_client = Deal.where(client: self).where.not(advisor_review: nil)
    # TODO: Try to write a join query to order by dates
    deals_as_advisor.or(deals_as_client).order(client_review_at: :desc)
  end


  # Facebook oauth

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

  # Validations

  def birth_date_must_be_valid
    errors.add(:birth_date, "Enter a valid birthdate") if
      birth_date.present? && (birth_date > DateTime.current.in_time_zone || birth_date < 130.years.ago)
  end

end
