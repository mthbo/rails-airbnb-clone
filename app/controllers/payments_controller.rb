class PaymentsController < ApplicationController
  before_action :find_deal, only: [:create]
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized, only: [:create]

  def create
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @deal.total_amount_cents,
      description:  "Payment of user #{@deal.client.id} for #session-#{@deal.id}",
      currency:     @deal.total_amount.currency
    )

    @deal.opened_at = DateTime.current.in_time_zone
    @deal.payment = charge.to_json
    @deal.advisor_notifications += 1
    @deal.client_notifications = 0
    @deal.save
    @deal.opened!
    @deal.paid!
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    DealCardsBroadcastJob.perform_later(@deal)
    send_status_message
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    DealMailer.deal_proposition_accepted_advisor(@deal).deliver_later
    DealMailer.deal_proposition_accepted_client(@deal).deliver_later
    respond_to do |format|
      format.html {
        flash[:notice] = "#session-#{@deal.id} with #{@deal.advisor.name_anonymous} is open!"
        # flash[:notice] = t('.notice', id: @deal.id, name: @deal.advisor.first_name)
        redirect_to deal_path(@deal)
      }
      format.js
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to deal_path(@deal)
  end

private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def send_status_message
    message = Message.new(deal: @deal, user: current_user)
    message.build_deal_status_message
    message.save
  end

end
