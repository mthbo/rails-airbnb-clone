class Language < ApplicationRecord
  has_many :offer_languages
  has_many :offers, through: :offer_languages

  default_scope -> { order(name: :ASC) }

  FLAGS = {
    "French" => "france.svg",
    "English" => "united-kingdom.svg",
    "Spanish" => "spain.svg",
    "Italian" => "italy.svg",
    "German" => "germany.svg",
    "Chinese" => "china.svg",
    "Danish" => "denmark.svg",
    "Dutch" => "netherlands.svg",
    "Hindi" => "india.svg",
    "Japanese" => "japan.svg",
    "Portuguese" => "portugal.svg",
    "Russian" => "russia.svg",
    "Swahili" => "kenya.svg",
    "Arabic" => "saudi-arabia.svg",
  }

  def flag
    FLAGS[self.name]
  end

  def name_illustrated
    "<span class='flag-icon'>".html_safe + ActionController::Base.helpers.image_tag("flags/#{self.flag}") + " #{self.name}</span>".html_safe
  end
end
