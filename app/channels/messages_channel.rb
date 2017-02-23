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

  def type(data)
    TypingBroadcastJob.perform_later(data['deal_id'], current_user.id, data['state'])
  end

end
