class Mean < ApplicationRecord
  has_many :offer_means, dependent: :destroy
  has_many :offers, through: :offer_means
  has_many :deal_means, dependent: :destroy
  has_many :deals, through: :deal_means

  PICTOS = {
    "Messaging" => 'comments',
    "Phone call" => 'phone',
    "Video call" => 'video-camera',
    "Meeting" => 'coffee',
    "Documents" => 'file-text',
    "Sign language" => 'sign-language'
  }

  def name_translated(locale=I18n.locale)
    I18n.t("mean.#{name.downcase.split.join("_")}", locale: locale)
  end

  def picto
    PICTOS[self.name]
  end

  def picto_i
    "<i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i>".html_safe
  end

  def name_illustrated(locale=I18n.locale)
    "<span class='mean-icon mean-icon-long'>".html_safe + picto_i + "#{self.name_translated(locale)}</span>".html_safe
  end

  def offers_count
    offers.count
  end

  def deals_count
    deals.count
  end

end
