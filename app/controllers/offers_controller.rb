class OffersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_offer, only: [:show, :edit, :update, :destroy]

  def index
    @offers = policy_scope(Offer)
  end

  def show
    @deal = deal_ongoing.present? ? deal_ongoing : @offer.deals.new
    @pinned_offer = offer_pinned.present? ? offer_pinned : @offer.pinned_offers.new
  end

  def new
    @offer = current_user.offers.new
    authorize @offer
  end

  def create
    @offer = current_user.offers.new(offer_params)
    authorize @offer
    if @offer.save
      flash[:notice] = "#{@offer.title} has been created"
      redirect_to offer_path(@offer)
    else
      flash[:alert] = "No offer has been created"
      render :new
    end
  end

  def edit
  end

  def update
    if @offer.update(offer_params)
      flash[:notice] = "#{@offer.title} has been updated"
      redirect_to offer_path(@offer)
    else
      flash[:alert] = "Offer has not been updated"
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to @offer.advisor
  end

  private

  def find_offer
    @offer = Offer.find(params[:id])
    authorize @offer
  end

  def offer_params
    params.require(:offer).permit(:title, :description, mean_ids: [], language_ids: [])
  end

  def deal_ongoing
    @offer.deals.where(client: current_user).where.not(status: :closed).last
  end

  def offer_pinned
    @offer.pinned_offers.where(client: current_user).last
  end

end
