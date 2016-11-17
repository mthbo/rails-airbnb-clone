class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :offers, foreign_key: 'advisor_id', dependent: :destroy
  has_many :deals, foreign_key: 'client_id'
  has_many :advisor_deals, through: :offers, source: :deals

  has_attachment :photo

  def name_anonymous
    "#{first_name} #{last_name.first}."
  end

  def grade
    if advisor_deals_closed.count > 20
      "Champion"
    elsif advisor_deals_closed.count > 10
      "Senior Advisor"
    elsif advisor_deals_closed.count > 3
      "Advisor"
    else
      "Roockie"
    end
  end

  def advisor_deals_request
    advisor_deals.where(proposition_at: nil)
  end

  def advisor_deals_proposition
    advisor_deals.where('proposistion_at IS NOT NULL and accepted_at IS NULL')
  end

  def advisor_deals_open
    advisor_deals.where('accepted_at IS NOT NULL and closed_at IS NULL')
  end

  def advisor_deals_closed
    advisor_deals.where.not(closed_at: nil)
  end

  def advisor_deals_reviewed
    advisor_deals.where.not(client_review: nil)
  end

  def deals_request
    deals.where(proposition_at: nil)
  end

  def deals_proposition
    deals.where('proposition_at IS NOT NULL and accepted_at IS NULL')
  end

  def deals_open
    deals.where('accepted_at IS NOT NULL and closed_at IS NULL')
  end

  def deals_closed
    deals.where.not(closed_at: nil)
  end

  def deals_reviewed
    deals.where.not(client_review: nil)
  end

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

end
