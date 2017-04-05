class Objective < ApplicationRecord
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  validates :description, presence: { message: "The objective must be specified" }
  validates :rating, numericality: { only_integer: true }, inclusion: { in: [1,2,3,3,4,5], message: "Rate from 1 to 5 stars"}, allow_nil: true

  EVALUATIONS = {
    1 => I18n.t('objective.irrelevant'),
    2 => I18n.t('objective.incomplete'),
    3 => I18n.t('objective.fair'),
    4 => I18n.t('objective.satisfactory'),
    5 => I18n.t('objective.outstanding')
  }

end
