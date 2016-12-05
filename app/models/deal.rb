class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  monetize :amount_cents
  enum status: [ :interest, :request, :proposition, :open, :closed ]

  def advisor
    self.offer.advisor
  end

end
