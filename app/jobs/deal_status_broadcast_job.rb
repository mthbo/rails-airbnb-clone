class DealStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, user)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{user.id}:status",
      status: render_status(deal, user),
      info: render_info(deal, user),
      actions: render_actions(deal, user)
    )
  end

  private

  def render_status(deal, user)
    ApplicationController.render_with_signed_in_user(user, partial: 'deals/status', locals: { deal: deal })
  end

  def render_info(deal, user)
    ApplicationController.render_with_signed_in_user(user, partial: 'deals/info', locals: { deal: deal })
  end

  def render_actions(deal, user)
    ApplicationController.render_with_signed_in_user(user, partial: 'deals/actions', locals: { deal: deal })
  end
end
