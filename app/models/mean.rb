class Mean < ApplicationRecord
  has_many :offer_means
  has_many :offers, through: :offer_means

  PICTO = {
      "SMS" => 'fa-mobile fa-lg',
      "Visio-call" => 'fa-video-camera fa-lg',
      "Call" => 'fa-phone fa-lg',
      "Email" => 'fa-envelope fa-lg',
      "Meeting" => 'fa-comments fa-lg',
    }


  def picto
    PICTO[self.name]
  end
end
