class DealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.advisor.id}:cards",
      card: render_deal_card(deal, deal.advisor),
      status: deal.general_status
    )
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{deal.client.id}:cards",
      card: render_deal_card(deal, deal.client),
      status: deal.general_status
    )
  end

  private

  def render_deal_card(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
  end
end
