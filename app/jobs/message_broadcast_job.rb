class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      "deal_#{message.deal_id}:messages",
      message: render_message(message),
      state: "sending",
      user_id: message.user.id
    )
  end

  private

  def render_message(message)
    ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/show', locals: { message: message })
  end
end
