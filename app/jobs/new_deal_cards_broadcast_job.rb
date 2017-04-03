class NewDealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "new_deal_user_#{deal.advisor.id}:cards",
      card: render_deal_card(deal, deal.advisor),
      deal_id: deal.id,
      free: deal.free?
    )
    ActionCable.server.broadcast(
      "new_deal_user_#{deal.client.id}:cards",
      card: render_deal_card(deal, deal.client),
      deal_id: deal.id,
      free: deal.free?
    )
    ActionCable.server.broadcast(
      "user_#{deal.advisor.id}:notifications",
      notifications: render_user_notifications(deal.advisor)
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
