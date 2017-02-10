class Mean < ApplicationRecord
  has_many :offer_means, dependent: :destroy
  has_many :offers, through: :offer_means
  has_many :deal_means, dependent: :destroy
  has_many :deals, through: :deal_means

  PICTOS = {
    "Messaging" => 'comments',
    "Call" => 'phone',
    "Video call" => 'video-camera',
    "Meeting" => 'coffee',
    "Documents" => 'file-text',
    "Sign language" => 'sign-language'
  }

  def picto
    PICTOS[self.name]
  end

  def name_illustrated
    "<span class='mean-icon mean-icon-long'><i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i> #{self.name}</span>".html_safe
  end

  def offers_count
    offers.count
  end

  def deals_count
    deals.count
  end

end
