class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  has_many :objectives, dependent: :destroy
  has_many :deal_means, dependent: :destroy
  has_many :means, through: :deal_means
  has_many :deal_languages, dependent: :destroy
  has_many :languages, through: :deal_languages
  has_many :messages, dependent: :destroy

  monetize :amount_cents
  enum status: [ :request, :proposition, :proposition_declined, :open, :closed, :cancelled ]

  validates :proposition, presence: true, on: :proposition
  validates :request, presence: true
  validates :deadline, presence: true
  validates :languages, presence: { message: "At least one language must me selected" }
  validates :means, presence: { message: "At least one mean of communication must me selected" }

  def advisor
    offer.advisor
  end

  def proposition_any?
    proposition? || proposition_declined?
  end

  def rating
    if rated_objectives.present?
      sum = 0
      rated_objectives.each { |objective| sum += objective.rating }
      sum.fdiv(rated_objectives.count)
    else
      nil
    end
  end

  def rated_objectives
    objectives.where.not(rating: nil)
  end

end
