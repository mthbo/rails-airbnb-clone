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

  def name_translated
    I18n.translate("mean.#{name.downcase.split.join("_")}")
  end

  def name_translated_en
    I18n.translate("mean.#{name.downcase.split.join("_")}", locale: :en)
  end

  def name_translated_fr
    I18n.translate("mean.#{name.downcase.split.join("_")}", locale: :fr)
  end

  def picto
    PICTOS[self.name]
  end

  def name_illustrated
    "<span class='mean-icon mean-icon-long'><i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i> #{self.name_translated}</span>".html_safe
  end

  def name_illustrated_en
    "<span class='mean-icon mean-icon-long'><i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i> #{self.name_translated_en}</span>".html_safe
  end

  def name_illustrated_fr
    "<span class='mean-icon mean-icon-long'><i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i> #{self.name_translated_fr}</span>".html_safe
  end

  def offers_count
    offers.count
  end

  def deals_count
    deals.count
  end

end
