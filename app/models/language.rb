class Language < ApplicationRecord
  has_many :offer_languages, dependent: :destroy
  has_many :offers, through: :offer_languages
  has_many :deal_languages, dependent: :destroy
  has_many :deals, through: :deal_languages

  default_scope -> { order(name: :ASC) }

  FLAGS = {
    "French" => "france.svg",
    "English" => "united-kingdom.svg",
    "Spanish" => "spain.svg",
    "Italian" => "italy.svg",
    "German" => "germany.svg",
    "Mandarin" => "china.svg",
    "Danish" => "denmark.svg",
    "Dutch" => "netherlands.svg",
    "Hindi" => "india.svg",
    "Japanese" => "japan.svg",
    "Portuguese" => "portugal.svg",
    "Russian" => "russia.svg",
    "Swahili" => "kenya.svg",
    "Arabic" => "saudi-arabia.svg",
  }

  def name_translated(locale=I18n.locale)
    I18n.t("language.#{name.downcase.split.join("_")}", locale: locale)
  end

  def flag
    FLAGS[self.name]
  end

  def flag_img
    ActionController::Base.helpers.image_tag("flags/#{self.flag}")
  end

  def name_illustrated(locale=I18n.locale)
    "<span class='flag-icon flag-icon-long'>".html_safe + ActionController::Base.helpers.image_tag("flags/#{self.flag}") + " #{self.name_translated(locale)}</span>".html_safe
  end

  def offers_count
    offers.count
  end

  def deals_count
    deals.count
  end
end
