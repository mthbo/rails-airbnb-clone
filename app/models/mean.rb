class Mean < ApplicationRecord
  has_many :offer_means
  has_many :offers, through: :offer_means

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
end
