class NewDealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "new_deal_user_#{deal.advisor.id}:cards",
      card: render_deal_card(deal, deal.advisor),
      deal_id: deal.id
    )
    ActionCable.server.broadcast(
      "new_deal_user_#{deal.client.id}:cards",
      card: render_deal_card(deal, deal.client),
      deal_id: deal.id
    )
  end

  private

  def render_deal_card(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
  end
end
