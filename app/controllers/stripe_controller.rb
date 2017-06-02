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
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      render status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render status: 400
      return
    end

    case event.try(:type)
    when 'account.updated'
      @user = params[:account] && User.find_by( stripe_account_id: params[:account] )
      if @user
        payouts_enabled = event.data.object.payouts_enabled
        charges_enabled = event.data.object.charges_enabled
        (payouts_enabled && charges_enabled) ? @user.pricing_enabled! : @user.pricing_disabled!
      end
    end

    render status: 200
  end
end
