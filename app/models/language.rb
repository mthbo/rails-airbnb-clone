class Language < ApplicationRecord
  has_many :offer_languages, dependent: :destroy
  has_many :offers, through: :offer_languages
  has_many :deal_languages, dependent: :destroy
  has_many :deals, through: :deal_languages

  validates :name, presence: true
  validates :code, presence: true

  default_scope -> { order(code: :ASC) }

  def name_formatted
    name.downcase.split.join("_")
  end

  def name_translated(locale=I18n.locale)
    I18n.t("language.#{name_formatted}", locale: locale)
  end

  def flag
    "#{self.code}.svg"
  end

  def flag_path
    ActionController::Base.helpers.image_path("flags/#{self.flag}")
  end

  def flag_img
    ActionController::Base.helpers.image_tag("flags/#{self.flag}", alt: name_formatted)
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
