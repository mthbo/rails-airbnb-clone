class Deal < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :offer

  validates :request, presence: true

  def advisor
    self.offer.advisor
  end

  def status
    if !closed_at.nil?
      "Closed"
    elsif !accepted_at.nil?
      "Open"
    elsif !proposition_at.nil?
      "Proposition"
    else
      "Request"
    end
  end

  def proposition?
    !proposition_at.nil?
  end

  def accepted?
    !accepted_at.nil?
  end

  def closed?
    !closed_at.nil?
  end
end
