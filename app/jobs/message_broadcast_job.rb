class MessageBroadcastJob < ApplicationJob
  queue_as :critical

  def perform(message)
    I18n.available_locales.each do |locale|
      ActionCable.server.broadcast(
        "deal_#{message.deal_id}:messages_#{locale}",
        message: render_message(message, locale),
        state: "sending",
        target: message.target,
        user_id: message.user.id
      )
    end
  end

  private

  def render_message(message, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/show', locals: { message: message })
    end
  end
end
