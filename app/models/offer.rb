class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  validates :title, presence: { message: "The offer must have a title" }
  validates :description, presence: { message: "The offer must have a description" }
  validates :languages, presence: { message: "At least one language must me selected" } , length: { in: 1..5 }
  validates :means, presence: { message: "At least one mean of communication must me selected" }

  def global_rating
    if deals_reviewed.present?
      sum = 0
      deals_reviewed.each { |deal| sum += deal.rating }
      return sum.fdiv(deals_reviewed.count)
    else
      return nil
    end
  end

  def min_amount
    Money.new(deals_closed.minimum(:amount_cents))
  end

  def max_amount
    Money.new(deals_closed.maximum(:amount_cents))
  end

  def median_amount
    if deals_closed.present?
      amounts = []
      deals_closed.each { |deal| amounts << deal.amount_cents }
      amounts.sort!
      len = amounts.length
      median_cents = (amounts[(len - 1) / 2] + amounts[len / 2]) / 2
      Money.new(median_cents)
    end
  end

  def deals_closed
    deals.where(status: :closed)
  end

  def deals_reviewed
    deals.where.not(client_review: nil)
  end

end
