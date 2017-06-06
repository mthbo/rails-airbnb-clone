class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def webhook
    endpoint_secret = ENV['STRIPE_ENDPOINT_SECRET']
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      @event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      render status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render status: 400
      return
    end

    @user = params[:account] && User.find_by( stripe_account_id: params[:account] )
    if @user.present?
      case @event.try(:type)

      when 'account.updated'
        payouts_enabled = @event.data.object.payouts_enabled
        charges_enabled = @event.data.object.charges_enabled
        (payouts_enabled && charges_enabled) ? @user.pricing_enabled! : @user.pricing_disabled!

      when 'payout.paid'
        retrieve_payout_deal
        @deal.payout_made! if @deal.present?

      when 'payout.failed'
        retrieve_payout_deal
        @deal.payout_failed! if @deal.present?

      end
    end

    render status: 200
  end

  private

  def retrieve_payout_deal
    payout_id = @event.data.object.id
    payout = Stripe::Payout.retrieve(payout_id, {stripe_account: params[:account] })
    deal_id = payout.metadata.deal_id if payout.present?
    @deal = Deal.find(deal_id) if deal_id.present?
  end
end
