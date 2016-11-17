class DealsController < ApplicationController
  before_action :find_deal, only: [:show]
  before_action :find_offer, only: [:create, :new, :show]

  def show
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = @offer.deals.new(deal_params)
    @deal.client = current_user
    if @deal.save
      flash[:notice] = "A request has been sent to #{@offer.advisor.name_anonymous} regarding the offer '#{@offer.title}'"
      redirect_to offer_path(@offer)
    else
      flash[:alert] = "No request has been sent"
      render :new
    end
  end

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

  private

  def find_deal
    @deal = Deal.find(params[:id])
  end

  def find_offer
    @offer = Offer.find(params[:offer_id])
  end

  def deal_params
    params.require(:deal).permit(:request, :deadline)
  end

end
