class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      "deal_#{message.deal_id}:messages",
      content: message.content_formatted,
      user_id: message.user_id,
      date: message.date_formatted,
      state: "sending"
    )
  end

end
