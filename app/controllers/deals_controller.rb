class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :update, :proposition]
  before_action :find_offer, only: [:new, :create]
  layout 'devise', only: [:new, :create, :proposition, :update]

  def show
    @message = Message.new
  end

  def new
    @deal = @offer.deals.new
    authorize @deal
  end

  def create
    @deal = @offer.deals.new(deal_params)
    authorize @deal
    @deal.client = current_user
    if @deal.save
      flash[:notice] = "A request has been sent to #{@offer.advisor.name_anonymous} for the offer '#{@offer.title}'"
      redirect_to deal_path(@deal)
    else
      render :new
    end
  end

  def proposition
  end

  def update
    if @deal.update(deal_params)
      redirect_to deal_path(@deal)
      flash[:notice] = "Session has been updated"
    else
      render :proposition
    end
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
    authorize @deal
  end

  def find_offer
    @offer = Offer.find(params[:offer_id])
  end

  def deal_params
    params.require(:deal).permit(
      :offer_id,
      :request,
      :status,
      :deadline,
      :amount,
      :proposition,
      :request_at,
      :proposition_at,
      :accepted_at,
      :closed_at,
      :proposition_deadline,
      mean_ids: [],
      language_ids: []
    )
  end

end
