class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :update]
  before_action :find_offer, only: [:create, :new, :show, :update]

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

  def update
    if @deal.update(deal_params)
      flash[:notice] = "A proposition has been sent to #{@deal.client.name_anonymous} regarding the offer '#{@offer.title}'"
      redirect_to offer_deal_path(@offer, @deal)
    else
      flash[:alert] = "No request has been sent"
      render 'deal/show'
    end
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
  end

  def find_offer
    @offer = Offer.find(params[:offer_id])
  end

  def deal_params
    params.require(:deal).permit(:request, :deadline, :price, :proposition, :proposition_at, :accepted_at, :closed_at)
  end

end
