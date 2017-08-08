class IndexUserOffersJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.offers_active.each { |offer| offer.index! } if user.present?
  end

end
