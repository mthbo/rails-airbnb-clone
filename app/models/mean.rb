class Mean < ApplicationRecord
  has_many :offer_means
  has_many :offers, through: :offer_means

  default_scope -> { order(name: :ASC) }

  PICTOS = {
    "SMS" => 'comments',
    "Visio-call" => 'video-camera',
    "Call" => 'phone',
    "Email" => 'envelope',
    "Meeting" => 'coffee'
  }

  def picto
    PICTOS[self.name]
  end

  def name_illustrated
    "<i class='fa fa-#{self.picto} fa-fw fa-lg' aria-hidden='true'></i> #{self.name}".html_safe
  end
end
