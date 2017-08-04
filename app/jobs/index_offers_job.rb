class IndexOffersJob < ApplicationJob
  queue_as :default

  def perform(offers)
    offers.each { |offer| offer.index! if offer.present? }
  end

end
