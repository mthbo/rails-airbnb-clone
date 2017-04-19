class Objective < ApplicationRecord
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  validates :description, presence: true, length: { maximum: 150 }
  validates :rating, numericality: { only_integer: true }, inclusion: { in: [1,2,3,3,4,5] }, allow_nil: true

  EVALUATIONS = {
    1 => 'irrelevant',
    2 => 'incomplete',
    3 => 'fair',
    4 => 'satisfactory',
    5 => 'outstanding'
  }

  def self.evaluations
    (1..5).to_a.map { |rating| [rating, {'data-html' => I18n.t("objective.#{EVALUATIONS[rating]}") }] }
  end

  def evaluation
    I18n.t("objective.#{EVALUATIONS[self.rating]}")
  end

end
