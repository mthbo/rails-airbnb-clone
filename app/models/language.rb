class Language < ApplicationRecord
  has_many :offer_languages
  has_many :offers, through: :offer_languages

  FLAGS = {
  "French" => "france.png",
  "English" => "united-kingdom.png",
  "Spanish" => "spain.png",
  "Italian" => "italy.png",
  "German" => "germany.png",
  "Chinese" => "china.png",
  "Danish" => "denmark.png",
  "Dutch" => "netherlands.png",
  "Hindi" => "india.png",
  "Japanese" => "japan.png",
  "Portuguese" => "portugal.png",
  "Russian" => "russia.png",
  "Swahili" => "kenya.png",
  "Arabic" => "saudi-arabia.png",
  }

  def flag
    FLAGS[self.name]
  end
end
