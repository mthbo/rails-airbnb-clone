class PaymentsController < ApplicationController
  before_action :find_deal, only: [:new, :create]
  skip_after_action :verify_authorized, only: [:new, :create]

  def new
  end

  def create
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @deal.amount_cents,
      description:  "Payment for #session-#{@deal.id}",
      currency:     @deal.amount.currency
    )

    @deal.update(payment: charge.to_json, payment_state: 'paid', status: 'open', open_at: DateTime.current.in_time_zone)
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    send_status_message
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    redirect_to deal_path(@deal)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_deal_payment_path(@deal)
  end

private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def send_status_message
    message = Message.new(deal: @deal, user: current_user, target: "deal_status")
    message.build_deal_status_content
    message.save
  end

end
