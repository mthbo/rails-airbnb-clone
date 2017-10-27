class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :advisor, :legal, :terms, :privacy]
  before_action :set_offer_sample, only: [:home]
  before_action :set_admin_offer, only: [:advisor]
  layout 'client_form', only: [:contact]

  def home
  end

  def advisor
  end

  def legal
  end

  def terms
  end

  def privacy
  end

  private

  def set_offer_sample
    @offer_sample = []
    offer_ids = ENV['OFFER_SAMPLE_3_IDS']
    if offer_ids.present?
      offer_ids.split.each do |id|
        offer = Offer.find_by_id(id.to_i)
        if offer.present? && offer.active?
          @offer_sample << offer
        else
          rand_offer = Offer.active.sample
          rand_offer = Offer.active.sample while @offer_sample.include? rand_offer
          @offer_sample << rand_offer
        end
      end
    else
      @offer_sample = Offer.active.sample(3)
    end
  end

  def set_admin_offer
    offer_id = ENV['OFFER_ADMIN_ID']
    @offer = Offer.find_by_id(offer_id.to_i) if offer_id.present?
    @offer ||= Offer.first
  end

end
