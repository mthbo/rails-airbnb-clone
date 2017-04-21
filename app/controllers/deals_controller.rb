class DealsController < ApplicationController
  before_action :find_deal, only: [:show, :new_proposition, :save_proposition, :submit_proposition, :decline_proposition, :open_session, :close_session, :new_review, :save_review, :disable_messages, :cancel_session]
  before_action :find_offer, only: [:new, :create]

  def show
    @message = Message.new
    if current_user == @deal.client
      @deal.client_notifications = 0
    elsif current_user == @deal.advisor
      @deal.advisor_notifications = 0
    end
    @deal.save(validate: false)
    DealNotificationsBroadcastJob.perform_later(@deal)
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
    @deal.advisor_notifications += 1
    if @deal.save
      send_first_message
      NewDealCardsBroadcastJob.perform_later(@deal)
      RequestExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
      DealMailer.deal_request(@deal).deliver_later
      flash[:notice] = t('.notice', name: @offer.advisor.first_name, title: @offer.title)
      redirect_to deal_path(@deal)
    else
      render :new, layout: "client_form"
    end
  end

  def new_proposition
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
    @deal.payment_pending! unless (@deal.amount.blank? || @deal.amount.zero?)
    @deal.proposition_at = DateTime.current.in_time_zone
    @deal.client_notifications += 1
    @deal.advisor_notifications = 0
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, @deal.client)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    PropositionExpiryJob.set(wait_until: @deal.proposition_deadline.end_of_day).perform_later(@deal)
    DealMailer.deal_proposition(@deal).deliver_later
    flash[:notice] = t('.notice', name: @deal.client.first_name)
    redirect_to deal_path(@deal)
  end

  def decline_proposition
    @deal.proposition_declined!
    @deal.no_payment!
    @deal.advisor_notifications += 1
    @deal.client_notifications = 0
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    DealMailer.deal_proposition_declined(@deal).deliver_later
    respond_to do |format|
      format.html {
        flash[:alert] = t('.notice', name: @deal.advisor.first_name)
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def open_session
    @deal.opened!
    @deal.opened_at = DateTime.current.in_time_zone
    @deal.advisor_notifications += 1
    @deal.client_notifications = 0
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    DealMailer.deal_proposition_accepted_advisor(@deal).deliver_later
    DealMailer.deal_proposition_accepted_client(@deal).deliver_later
    respond_to do |format|
      format.html {
        flash[:notice] = t('.notice', id: @deal.id, name: @deal.advisor.first_name)
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def close_session
    @deal.closed!
    @deal.closed_at = DateTime.current.in_time_zone
    if @deal.client == current_user
      receiver = @deal.advisor
      @deal.advisor_notifications += 1
      @deal.client_notifications = 0
    elsif @deal.advisor == current_user
      receiver = @deal.client
      @deal.client_notifications += 1
      @deal.advisor_notifications = 0
    end
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, receiver)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    DealMailer.deal_closed_client(@deal).deliver_later
    DealMailer.deal_closed_advisor(@deal).deliver_later
    offer = @deal.offer
    if offer.free_deals > 0
      offer.free_deals -= 1
      offer.save
      # offer.priced! if offer.free_deals == 0
    end
    @deal.offer.index!
    respond_to do |format|
      format.html {
        flash[:alert] = t('.notice', id: @deal.id, name: @deal.client == current_user ? @deal.advisor.first_name : @deal.client.first_name)
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def new_review
    render layout: current_user == @deal.advisor ? "advisor_form" : "client_form"
  end

  def save_review
    if @deal.update(deal_params)
      @deal.no_review!
      if @deal.client == current_user
        receiver = @deal.advisor
        @deal.advisor_notifications += 1
        @deal.client_notifications = 0
      elsif @deal.advisor == current_user
        receiver = @deal.client
        @deal.client_notifications += 1
        @deal.advisor_notifications = 0
      end
      @deal.save
      ReviewBroadcastJob.perform_later(@deal, receiver)
      DealCardsBroadcastJob.perform_later(@deal)
      DealMailer.deal_review_advisor(@deal).deliver_later if receiver == @deal.advisor
      DealMailer.deal_review_client(@deal).deliver_later if receiver == @deal.client
      flash[:notice] = t('.notice')
      redirect_to deal_path(@deal)
    else
      if current_user == @deal.advisor
        render :new_review, layout: "advisor_form"
      elsif current_user == @deal.client
        render :new_review, layout: "client_form"
      end
    end
    @deal.offer.index!
  end

  def disable_messages
    @deal.messages_disabled = true
    if @deal.client == current_user
      receiver = @deal.advisor
      @deal.advisor_notifications += 1
      @deal.client_notifications = 0
    elsif @deal.advisor == current_user
      receiver = @deal.client
      @deal.client_notifications += 1
      @deal.advisor_notifications = 0
    end
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, receiver)
    DealCardsBroadcastJob.perform_later(@deal)
    respond_to do |format|
      format.html {
        flash[:notice] = t('.notice', id: @deal.id)
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

  def cancel_session
    @deal.cancelled!
    @deal.messages_disabled = true
    if @deal.client == current_user
      receiver = @deal.advisor
      @deal.advisor_notifications += 1
      @deal.client_notifications = 0
    elsif @deal.advisor == current_user
      receiver = @deal.client
      @deal.client_notifications += 1
      @deal.advisor_notifications = 0
    end
    @deal.save
    DealStatusBroadcastJob.perform_later(@deal, receiver)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    DealMailer.deal_cancelled_advisor(@deal).deliver_later if receiver == @deal.advisor
    DealMailer.deal_cancelled_client(@deal).deliver_later if receiver == @deal.client
    respond_to do |format|
      format.html {
        flash[:alert] = t('.notice', id: @deal.id, name: @deal.client == current_user ? @deal.advisor.first_name : @deal.client.first_name)
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
      :messages_disabled,
      :deadline,
      :amount,
      :proposition,
      :proposition_at,
      :opened_at,
      :closed_at,
      :proposition_deadline,
      :who_reviews,
      :client_review,
      :client_review_at,
      :client_rating,
      :advisor_review,
      :advisor_review_at,
      :advisor_rating,
      mean_ids: [],
      language_ids: []
    )
  end

  def send_first_message
    message = Message.new(deal: @deal, user: @deal.client)
    message.build_first_message
    message.save
  end

  def send_status_message
    message = Message.new(deal: @deal, user: current_user)
    message.build_deal_status_message
    message.save
  end

end
