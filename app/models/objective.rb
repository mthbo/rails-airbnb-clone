class Objective < ApplicationRecord
  belongs_to :deal

  default_scope -> { order(created_at: :ASC) }

  validates :description, presence: { message: "The objective must be specified" }
  validates :rating, numericality: { only_integer: true }, inclusion: { in: [1,2,3,3,4,5], message: "Rate from 1 to 5 stars"}, allow_nil: true

  EVALUATIONS = {
    1 => "irrelevant",
    2 => "incomplete",
    3 => "fair",
    4 => "satisfactory",
    5 => "outstanding"
  }

end
