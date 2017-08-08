class IndexOfferJob < ApplicationJob
  queue_as :default

  def perform(offer)
    offer.index! if offer.present?
  end

end
