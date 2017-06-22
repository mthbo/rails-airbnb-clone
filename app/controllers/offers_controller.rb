class OffersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :find_offer, only: [:show, :edit, :update, :status, :pin]
  layout 'advisor_form', only: [:new, :create, :edit, :update]

  def show
    @deals_reviewed = @offer.deals_reviewed.page(params[:page])
  end

  def new
    @offer = current_user.offers.new
    authorize @offer
  end

  def create
    @offer = current_user.offers.new(offer_params)
    authorize @offer
    if @offer.save
      flash[:notice] = t('.notice', title: @offer.title)
      redirect_to offer_path(@offer)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @offer.update(offer_params)
      respond_to do |format|
        format.html {
          if @offer.archived?
            flash[:notice] = t('.notice_removed', title: @offer.title)
            redirect_to user_path(current_user)
          else
            flash[:notice] = t('.notice_updated', title: @offer.title)
            redirect_to offer_path(@offer)
          end
        }
        format.js
      end
    else
      render :edit
    end
  end

  def status
    if @offer.active?
      @offer.inactive!
    elsif @offer.inactive?
      @offer.active!
    end
  end

  def pin
    if current_user.liked?(@offer)
      current_user.unlike(@offer)
    else
      current_user.likes(@offer)
    end
  end

  private

  def find_offer
    @offer = Offer.find(params[:id])
    authorize @offer
  end

  def offer_params
    params.require(:offer).permit(:title, :description, :status, :pricing, :free_deals, mean_ids: [], language_ids: [])
  end

end
