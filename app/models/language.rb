class Language < ApplicationRecord
  has_many :offer_languages, dependent: :destroy
  has_many :offers, through: :offer_languages
  has_many :deal_languages, dependent: :destroy
  has_many :deals, through: :deal_languages

  default_scope -> { order(name: :ASC) }

  FLAGS = {
    "French" => "fr.svg",
    "English" => "en.svg",
    "Spanish" => "es.svg",
    "Italian" => "it.svg",
    "German" => "de.svg",
    "Chinese" => "zh.svg",
    "Danish" => "da.svg",
    "Dutch" => "nl.svg",
    "Hindi" => "hi.svg",
    "Japanese" => "ja.svg",
    "Russian" => "ru.svg",
    "Swahili" => "sw.svg",
    "Arabic" => "ar.svg",
    "Swedish" => "sv.svg",
    "Greek" => "gr.svg",
    "Malaysian" => "my.svg",
    "Indonesian" => "id.svg",
    "Hungarian" => "hu.svg",
    "Norwegian" => "nb.svg",
    "Polish" => "pl.svg",
    "Brazilian Portuguese" => "pt-BR.svg",
    "Portuguese" => "pt-PT.svg",
    "Finnish" => "fi.svg",
    "Turkish" => "tr.svg",
    "Icelandic" => "is.svg",
    "Czech" => "cs.svg",
    "Thai" => "th.svg",
    "Korean" => "ko.svg",
    "Persian" => "fa.svg",
    "Hebrew" => "he.svg"
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
