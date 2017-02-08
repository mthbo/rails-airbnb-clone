class MessageNotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{receiver.id}:notifications",
      notifications: render_notifications(deal, receiver),
    )
  end

  private

  def render_notifications(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/notifications', locals: { deal: deal })
  end
end
