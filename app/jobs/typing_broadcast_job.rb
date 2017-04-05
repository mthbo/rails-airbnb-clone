class TypingBroadcastJob < ApplicationJob
  queue_as :critical

  def perform(deal_id, user_id, state)
    I18n.available_locales.each do |locale|
      ActionCable.server.broadcast(
        "deal_#{deal_id}:messages_#{locale}",
        state: state,
        user_id: user_id
      )
    end
  end

end
