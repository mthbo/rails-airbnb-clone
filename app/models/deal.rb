class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer

  validates :request, presence: true

  def advisor
    self.offer.advisor
  end
end
