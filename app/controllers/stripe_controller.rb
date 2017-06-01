class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized

  def webhook
    # @user = params[:account] && User.find_by( stripe_account_id: params[:account] )
    User.last.update(bio: "yoyo")
    render nothing: true, status: 200
  end
end
