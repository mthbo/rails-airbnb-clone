class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer
  monetize :amount_cents
  enum status: [ :interest, :request, :proposition, :open, :closed ]

  def advisor
    self.offer.advisor
  end

  # def status
  #   if !closed_at.nil?
  #     "Closed"
  #   elsif !accepted_at.nil?
  #     "Open"
  #   elsif !proposition_at.nil?
  #     "Proposition"
  #   else
  #     "Request"
  #   end
  # end

  # def request?
  #   status == "Request"
  # end

  # def proposition?
  #   status == "Proposition"
  # end

  # def open?
  #   status == "Open"
  # end

  # def closed?
  #   status == "Closed"
  # end
end
