class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :update, :proposition]
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

  def update
    if @deal.update(deal_params)
      if @deal.waiting_proposition? && @deal.advisor == current_user
        respond_to do |format|
          format.js
        end
      elsif @deal.proposition?
        DealStatusBroadcastJob.perform_later(@deal, @deal.client)
        send_status_message
        PropositionExpiryJob.set(wait_until: @deal.proposition_deadline.end_of_day - 30.minutes).perform_later(@deal)
        flash[:notice] = "Your proposition was submitted to #{@deal.client.name_anonymous}"
        redirect_to deal_path(@deal)
      elsif @deal.proposition_declined? && @deal.client == current_user
        DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
        send_status_message
        respond_to do |format|
          format.html {
            flash[:alert] = "You declined the proposition of #{@deal.advisor.name_anonymous}"
            redirect_to deal_path(@deal)
          }
          format.js
        end
      elsif @deal.open?
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
      elsif @deal.closed? && @deal.client == current_user
        DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
        send_status_message
        respond_to do |format|
          format.html {
            flash[:alert] = "#session-#{@deal.id} with #{@deal.advisor.name_anonymous} is closed!"
            redirect_to deal_path(@deal)
          }
          format.js
        end
      elsif @deal.closed? && @deal.advisor == current_user
        DealStatusBroadcastJob.perform_later(@deal, @deal.client)
        send_status_message
        respond_to do |format|
          format.html {
            flash[:alert] = "#session-#{@deal.id} with #{@deal.client.name_anonymous} is closed!"
            redirect_to deal_path(@deal)
          }
          format.js
        end
      elsif @deal.cancelled? && @deal.client == current_user
        DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
        send_status_message
        respond_to do |format|
          format.html {
            flash[:alert] = "#session-#{@deal.id} with #{@deal.advisor.name_anonymous} has been cancelled."
            redirect_to deal_path(@deal)
          }
          format.js
        end
      elsif @deal.cancelled? && @deal.advisor == current_user
        DealStatusBroadcastJob.perform_later(@deal, @deal.client)
        send_status_message
        respond_to do |format|
          format.html {
            flash[:alert] = "#session-#{@deal.id} with #{@deal.client.name_anonymous} has been cancelled."
            redirect_to deal_path(@deal)
          }
          format.js
        end
      end
    else
      if @deal.waiting_proposition? && @deal.advisor == current_user
        respond_to do |format|
          format.js
        end
      else
        respond_to do |format|
          format.html { render :show }
          format.js
        end
      end
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
