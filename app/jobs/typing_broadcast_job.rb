class TypingBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal_id, user_id, state)
    ActionCable.server.broadcast(
      "deal_#{deal_id}:messages",
      state: state,
      user_id: user_id
    )
  end

end
