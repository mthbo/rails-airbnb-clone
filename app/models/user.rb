class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :offers, foreign_key: 'advisor_id', dependent: :destroy
  has_many :deals, foreign_key: 'client_id'
  has_many :advisor_deals, through: :offers, source: :deals

  def grade
    if advisor_deals_closed.count > 20
      return "Champion"
    elsif advisor_deals_closed.count > 10
      return "Senior Advisor"
    elsif advisor_deals_closed.count > 3
      return "Advisor"
    else
      return "Roockie"
    end
  end

  def advisor_deals_closed
    advisor_deals.where.not(closed_at: nil)
  end

  def advisor_deals_reviewed
    advisor_deals.where.not(client_review: nil)
  end

  def deals_closed
    deals.where.not(closed_at: nil)
  end

  def deals_reviewed
    deals.where.not(client_review: nil)
  end

end
