class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals
  has_many :offer_means, dependent: :destroy
  has_many :means, through: :offer_means
  has_many :offer_languages, dependent: :destroy
  has_many :languages, through: :offer_languages

  validates :title, presence: true
  validates :description, presence: true
  validates :languages, presence: true
  validates :means, presence: true

  def global_rating
    unless deals_reviewed.count.zero?
      sum = 0
      deals_reviewed.each { |deal| sum += deal.client_rating }
      sum.fdiv(deals_reviewed.count)
    end
  end

  def min_amount
    Money.new(deals_closed.minimum(:amount_cents))
  end

  def max_amount
    Money.new(deals_closed.maximum(:amount_cents))
  end

  def median_amount
    unless deals_closed.count.zero?
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
