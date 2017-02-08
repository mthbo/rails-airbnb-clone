class DealStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{receiver.id}:status",
      status: render_status(deal, receiver),
      info: render_info(deal, receiver),
      actions: render_actions(deal, receiver)
    )
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

  def render_status(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/status', locals: { deal: deal })
  end

  def render_info(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/info', locals: { deal: deal })
  end

  def render_actions(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/actions', locals: { deal: deal })
  end

  def render_deal_card(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
  end
end
