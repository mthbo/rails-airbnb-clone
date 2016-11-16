class Language < ApplicationRecord
  has_many :offer_languages
  has_many :offers, through: :offer_languages
end
