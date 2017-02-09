class DealNotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.advisor.id}:notifications",
      notifications: render_notifications(deal, deal.advisor),
    )
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.client.id}:notifications",
      notifications: render_notifications(deal, deal.client),
    )
  end

  private

  def render_notifications(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/notifications', locals: { deal: deal })
  end
end
