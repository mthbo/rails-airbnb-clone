class PaymentsController < ApplicationController
  include DealOpening
  before_action :find_deal, only: [:create]
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized, only: [:create]

  def create
    @customer = @deal.client.stripe_customer_id.present? ? Stripe::Customer.retrieve(@deal.client.stripe_customer_id) : nil
    (@customer.blank? || @customer.respond_to?(:deleted)) ? create_customer : update_customer
    create_charge
    open_deal

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
      email:  params[:stripeEmail],
      description: "#{@deal.client.first_name} #{@deal.client.last_name}"
    )
    @deal.client.update(stripe_customer_id: @customer.id)
  end

  def update_customer
    card = Stripe::Token.retrieve(params[:stripeToken]).card
    default_source = @customer.sources.data.select{|source| source.fingerprint == card.fingerprint}.last if card
    default_source = @customer.sources.create(card: params[:stripeToken]) unless default_source
    @customer.default_source = default_source.id
    @customer.email = params[:stripeEmail]
    @customer.description = "#{@deal.client.first_name} #{@deal.client.last_name}"
    @customer.save
  end

  def create_charge
    @charge = Stripe::Charge.create(
      customer:     @customer.id,
      amount:       @deal.amount_converted(current_user.currency).cents,
      description:  "##{t('session')}-#{@deal.id} | #{@deal.title}",
      currency:     @deal.amount_converted(current_user.currency).currency.to_s,
      destination: {
        amount: @deal.advisor_amount_converted(current_user.currency).cents,
        account: @deal.advisor.stripe_account_id,
      },
      metadata: { deal_id: @deal.id }
    )
    @deal.payment = @charge.to_json
    @deal.paid!
  end

end
