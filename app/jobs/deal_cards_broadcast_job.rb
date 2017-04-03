class DealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.advisor.id}:cards",
      card: render_deal_card(deal, deal.advisor),
      card_status: deal.card_status,
      general_status: deal.general_status,
      free: deal.free?
    )
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.client.id}:cards",
      card: render_deal_card(deal, deal.client),
      card_status: deal.card_status,
      general_status: deal.general_status,
      free: deal.free?
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

  def render_deal_card(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
  end

  def render_user_notifications(receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'users/notifications')
  end
end
