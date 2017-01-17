class TypingBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal_id, user, state)
    ActionCable.server.broadcast(
      "deal_#{deal_id}:messages",
      state: state,
      user_id: user.id
    )
  end

end
