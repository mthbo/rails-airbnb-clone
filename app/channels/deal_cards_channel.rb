class DealCardsChannel < ApplicationCable::Channel
  def subscribed
    deal = Deal.find(params[:deal_id])
    if current_user == deal.advisor || current_user == deal.client
      stream_from "deal_#{params[:deal_id]}_user_#{current_user.id}:cards"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
