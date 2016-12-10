class PinnedOffersController < ApplicationController
  before_action :find_pinned_offer, only: [:destroy]
  before_action :find_offer, only: [:create]

  def create
    @pinned_offer = @offer.pinned_offers.new
    authorize @pinned_offer
    @pinned_offer.client = current_user
    if @pinned_offer.save
      respond_to do |format|
        format.html { redirect_to offer_path(@offer) }
        format.js
      end
    end
  end

  def destroy
    @pinned_offer.destroy
    @offer = @pinned_offer.offer
    respond_to do |format|
      format.html { redirect_to offer_path(@offer) }
      format.js
    end
  end

  private

  def find_pinned_offer
    @pinned_offer = PinnedOffer.find(params[:id])
    authorize @pinned_offer
  end

  def find_offer
    @offer = Offer.find(params[:offer_id])
  end

end
