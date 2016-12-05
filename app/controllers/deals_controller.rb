class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :update, :destroy]
  before_action :find_offer, only: [:create]

  def show
  end

  def create
    @deal = @offer.deals.new(deal_params)
    authorize @deal
    @deal.client = current_user
    if @deal.interest?
      @deal.save
      redirect_to offer_path(@offer)
    else
      # work on this

      if @deal.save
        flash[:notice] = "A request has been sent to #{@offer.advisor.name_anonymous} for the offer '#{@offer.title}'"
        redirect_to deal_path(@deal)
      else
        flash[:alert] = "No request has been sent"
        render 'deals/request', offer: @offer, deal: @deal
      end
    end
  end

  def update

    # work on this

    if @deal.update(deal_params)
      flash[:notice] = "A proposition has been sent to #{@deal.client.name_anonymous} for the offer '#{@deal.offer.title}'"
      redirect_to deal_path(@deal)
    else
      flash[:alert] = "No request has been sent"
      render 'deal/show'
    end
  end

  def destroy
    @deal.destroy
    redirect_to @deal.offer
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
    authorize @deal
  end

  def find_offer
    @offer = Offer.find(params[:deal][:offer_id])
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
      mean_ids: [],
      language_ids: []
    )
  end

  def deal_interest
    @offer.deals.where(client: current_user, status: :interest).last
  end

  def deal_interest
  end

  def deal_request
  end

  def deal_proposition
  end

  def deal_acceptation
  end

  def deal_close
  end

end
