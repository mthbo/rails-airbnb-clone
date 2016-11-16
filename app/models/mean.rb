class Mean < ApplicationRecord
  has_many :offer_means
  has_many :offers, through: :offer_means
end
