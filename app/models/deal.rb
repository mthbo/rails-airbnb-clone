class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  has_many :objectives, dependent: :destroy
  has_many :deal_means, dependent: :destroy
  has_many :means, through: :deal_means
  has_many :deal_languages, dependent: :destroy
  has_many :languages, through: :deal_languages

  validates :languages, presence: { message: "At least one language must me selected" }, inclusion: { in: 1..5 }, unless: :interest?
  validates :means, presence: { message: "At least one mean of communication must me selected" }, unless: :interest?

  monetize :amount_cents
  enum status: [ :interest, :request, :proposition, :open, :closed ]

  def advisor
    self.offer.advisor
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
