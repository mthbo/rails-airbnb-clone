class PinnedOffer < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer

  validates :client, uniqueness: { scope: :offer, message: "This offer is already in your shortlist" }

  def advisor
    offer.advisor
  end
end
