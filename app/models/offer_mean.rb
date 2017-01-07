class OfferMean < ApplicationRecord
  belongs_to :mean
  belongs_to :offer

  default_scope -> { order(mean_id: :ASC) }
end
