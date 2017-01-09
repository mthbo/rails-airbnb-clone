class Objective < ApplicationRecord
  belongs_to :deal

  default_scope -> { order(updated_at: :ASC) }

  validates :description, presence: { message: "The objective must be specified" }
  # validates :rating, numericality: { only_integer: true }, inclusion: { in: [0,1,2,3,4,5], allow_nil: true }
end
