class DealStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, user)
    ActionCable.server.broadcast(
      "deal_#{deal.id}:status",
      status: render_status(deal, user)
    )
  end

  private

  def render_status(deal, user)
    ApplicationController.render_with_signed_in_user(user, partial: 'deals/status', locals: { deal: deal })
  end
end
