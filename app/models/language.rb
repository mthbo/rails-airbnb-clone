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

  def name_translated
    I18n.translate("language.#{name.downcase.split.join("_")}")
  end

  def name_translated_en
    I18n.translate("language.#{name.downcase.split.join("_")}", locale: :en)
  end

  def name_translated_fr
    I18n.translate("language.#{name.downcase.split.join("_")}", locale: :fr)
  end

  def flag
    FLAGS[self.name]
  end

  def flag_img
    ActionController::Base.helpers.image_tag("flags/#{self.flag}")
  end

  def name_illustrated
    "<span class='flag-icon flag-icon-long'>".html_safe + ActionController::Base.helpers.image_tag("flags/#{self.flag}") + " #{self.name_translated}</span>".html_safe
  end

  def name_illustrated_en
    "<span class='flag-icon flag-icon-long'>".html_safe + ActionController::Base.helpers.image_tag("flags/#{self.flag}") + " #{self.name_translated_en}</span>".html_safe
  end

  def name_illustrated_fr
    "<span class='flag-icon flag-icon-long'>".html_safe + ActionController::Base.helpers.image_tag("flags/#{self.flag}") + " #{self.name_translated_fr}</span>".html_safe
  end

  def offers_count
    offers.count
  end

  def deals_count
    deals.count
  end
end
