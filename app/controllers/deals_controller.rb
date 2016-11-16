class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @deal = Deal.new
  end

#   def create
#     @deal = current_user.offers.new(offer_params)
#     if @offer.save
#       flash[:notice] = "#{@offer.title} has been created"
#       redirect_to offer_path(@offer)
#     else
#       flash[:alert] = "No offer has been created"
#       render :new
#     end
#   end

#   def edit
#   end

#   def update
#     if @offer.update(offer_params)
#       flash[:notice] = "#{@offer.title} has been updated"
#       redirect_to offer_path(@offer)
#     else
#       flash[:alert] = "Offer has not been updated"
#       render :edit
#     end
#   end

#   def destroy
#     @offer.destroy
#     redirect_to user
#   end

#   private

#   def find_deal
#     @deal = Deal.find(params[:id])
#   end

#   def find_offer
#     @offer = Offer.find(params[:id])
#   end

#   def offer_params
#     params.require(:offer).permit(:title, :description)
#   end

end
