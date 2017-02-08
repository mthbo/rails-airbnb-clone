class NewDealCardsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_deal_user_#{current_user.id}:cards"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
