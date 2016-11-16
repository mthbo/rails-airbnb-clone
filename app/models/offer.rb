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

  def min_price
    deals_closed.minimum(:price)
  end

  def max_price
    deals_closed.maximum(:price)
  end

  def median_price
    unless deals_closed.count.zero?
      prices = []
      deals_closed.each { |deal| prices << deal.price }
      prices.sort!
      len = prices.length
      (prices[(len - 1) / 2] + prices[len / 2]) / 2
    end
  end

  def deals_closed
    deals.where.not(closed_at: nil)
  end

  def deals_reviewed
    deals.where.not(client_review: nil)
  end

end
