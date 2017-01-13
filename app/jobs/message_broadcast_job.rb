class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      "deal_#{message.deal_id}:messages",
      content: message.content_formatted,
      user_id: message.user_id,
      created_at: message.created_at
    )
  end

end
