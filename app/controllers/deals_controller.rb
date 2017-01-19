class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :proposition, :save_proposition, :submit_proposition, :decline_proposition, :accept_proposition, :close, :cancel]
  before_action :find_offer, only: [:new, :create]

  def show
    @message = Message.new
  end

  def new
    @deal = @offer.deals.new
    authorize @deal
    render layout: "client_form"
  end

  def create
    @deal = @offer.deals.new(deal_params)
    authorize @deal
    @deal.client = current_user
    if @deal.save
      flash[:notice] = "A request has been sent to #{@offer.advisor.name_anonymous} for the offer '#{@offer.title}'"
      send_first_message
      redirect_to deal_path(@deal)
    else
      render :new, layout: "client_form"
    end
  end

  def proposition
    @objective = Objective.new
    render layout: "advisor_form"
  end

  def save_proposition
    if @deal.update(deal_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def submit_proposition
    @deal.proposition!
    @deal.proposition_at = DateTime.current.in_time_zone
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, @deal.client)
    send_status_message
    PropositionExpiryJob.set(wait_until: @deal.proposition_deadline.end_of_day).perform_later(@deal)
    flash[:notice] = "Your proposition was submitted to #{@deal.client.name_anonymous}"
    redirect_to deal_path(@deal)
  end

  def decline_proposition
    @deal.proposition_declined!
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    send_status_message
    respond_to do |format|
      format.html {
        flash[:alert] = "You declined the proposition of #{@deal.advisor.name_anonymous}"
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def accept_proposition
    @deal.open!
    @deal.accepted_at = DateTime.current.in_time_zone
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    send_status_message
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    respond_to do |format|
      format.html {
        flash[:notice] = "#session-#{@deal.id} with #{@deal.advisor.name_anonymous} is open!"
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def close
    @deal.closed!
    @deal.closed_at = DateTime.current.in_time_zone
    @deal.save
    receiver = (@deal.client == current_user ? @deal.advisor : @deal.client)
    DealStatusBroadcastJob.perform_later(@deal, receiver)
    send_status_message
    respond_to do |format|
      format.html {
        flash[:alert] = "#session-#{@deal.id} with #{@deal.client == current_user ? @deal.advisor.name_anonymous : @deal.client.name_anonymous} is closed!"
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def cancel
    @deal.cancelled!
    receiver = (@deal.client == current_user ? @deal.advisor : @deal.client)
    DealStatusBroadcastJob.perform_later(@deal, receiver)
    send_status_message
    respond_to do |format|
      format.html {
        flash[:alert] = "#session-#{@deal.id} with #{@deal.client == current_user ? @deal.advisor.name_anonymous : @deal.client.name_anonymous} has been cancelled."
        redirect_to deal_path(@deal)
      }
      format.js
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

  def send_first_message
    message = Message.new(deal: @deal, user: @deal.client)
    message.build_first_content
    message.save
  end

  def send_status_message
    message = Message.new(deal: @deal, user: current_user, target: "deal_status")
    message.build_deal_status_content
    message.save
  end

end
