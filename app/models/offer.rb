class Offer < ApplicationRecord
  belongs_to :advisor, class_name: 'User'
  has_many :deals
  has_many :offer_means
  has_many :means, through: :offer_means
  has_many :offer_languages
  has_many :languages, through: :offer_languages

  validates :title, presence: true
  validates :description, presence: true
end