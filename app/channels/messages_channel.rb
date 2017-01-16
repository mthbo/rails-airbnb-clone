# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class MessagesChannel < ApplicationCable::Channel
  def subscribed
    deal = Deal.find(params[:deal_id])
    if current_user == deal.advisor || current_user == deal.client
      stream_from "deal_#{params[:deal_id]}:messages"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
