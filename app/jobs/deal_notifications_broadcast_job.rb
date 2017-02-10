class DealNotificationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.advisor.id}:notifications",
      notifications: render_deal_notifications(deal, deal.advisor)
    )
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.client.id}:notifications",
      notifications: render_deal_notifications(deal, deal.client)
    )
    ActionCable.server.broadcast(
      "user_#{deal.advisor.id}:notifications",
      notifications: render_user_notifications(deal.advisor)
    )
    ActionCable.server.broadcast(
      "user_#{deal.client.id}:notifications",
      notifications: render_user_notifications(deal.client)
    )
  end

  private

  def render_deal_notifications(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/notifications', locals: { deal: deal })
  end

  def render_user_notifications(receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'users/notifications')
  end
end
