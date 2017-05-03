class PaymentsController < ApplicationController
  before_action :find_deal, only: [:create]
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized, only: [:create]

  def create
    if @deal.client.stripe_customer_id
      @customer = Stripe::Customer.retrieve(@deal.client.stripe_customer_id)
      @customer.respond_to?(:deleted) ? create_customer : update_customer
    else
      create_customer
    end
    create_charge

    @deal.opened_at = DateTime.current.in_time_zone
    @deal.payment = @charge.to_json
    @deal.increment_notifications(@deal.advisor)
    @deal.reset_notifications(@deal.client)
    @deal.save
    @deal.opened!
    @deal.paid!
    @deal.client.update(stripe_customer_id: @customer.id)
    Message.create_status_message(@deal, current_user)
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    DealCardsBroadcastJob.perform_later(@deal)
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    DealMailer.deal_proposition_accepted_advisor(@deal).deliver_later
    DealMailer.deal_proposition_accepted_client(@deal).deliver_later
    respond_to do |format|
      format.html {
        flash[:notice] = t('deals.open_session.notice', id: @deal.id, name: @deal.advisor.first_name)
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

  def create_customer
    @customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )
  end

  def update_customer
    # existing_source_ids = @customer.sources.map { |source| source.id }
    # new_source = @customer.sources.new(source: params[:stripeToken])
    # new_source.save unless existing_source_ids.include?(new_source.id)
    @customer.source = params[:stripeToken]
    @customer.email = params[:stripeEmail]
    @customer.save
  end

  def create_charge
    @charge = Stripe::Charge.create(
      customer:     @customer.id,
      amount:       @deal.amount_cents,
      # application_fee: @deal.fees_cents,,
      # destination: @deal.advisor.stripe_account_id
      description:  "##{t('session')}-#{@deal.id} | #{@deal.title}",
      currency:     @deal.total_amount.currency
    )
  end

end
