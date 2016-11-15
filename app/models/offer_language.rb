class OfferLanguage < ApplicationRecord
  belongs_to :language
  belongs_to :offer
end
