class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :offers, foreign_key: 'advisor_id'
  has_many :deals, foreign_key: 'client_id'
  has_many :advisor_deals, through: :offers, source: :deals

  def grade
    if advisor_deals.count > 20
      return "Champion"
    elsif advisor_deals.count > 10
      return "Senior Advisor"
    elsif advisor_deals.count > 3
      return "Advisor"
    else
      return "Roockie"
    end
  end

end
