class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  has_many :objectives, dependent: :destroy
  has_many :deal_means, dependent: :destroy
  has_many :means, through: :deal_means
  has_many :deal_languages, dependent: :destroy
  has_many :languages, through: :deal_languages
  has_many :messages, dependent: :destroy

  monetize :amount_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

  enum status: [ :request, :proposition, :proposition_declined, :open, :open_expired, :closed, :cancelled ]

  validates :request, presence: true
  validates :deadline, presence: true
  validates :languages, presence: { message: "Select one language at least" }
  validates :means, presence: { message: "Select one mean of communication at least" }

  validates :proposition, presence: { message: "The proposition must be described" }, length: { minimum: 50, message: "The description is too short, please tell a little more!" }, if: :proposition?
  validates :proposition_deadline, presence: true, if: :proposition?
  validates :objectives, presence: true, length: { in: 1..10 }, if: :proposition?

  def advisor
    offer.advisor unless offer.nil?
  end

  def waiting_proposition?
    request? || proposition_declined?
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
