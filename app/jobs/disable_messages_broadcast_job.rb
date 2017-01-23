class DisableMessagesBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{receiver.id}:status",
      actions: render_actions(deal, receiver),
      info: render_info(deal, receiver),
      messages_disabled: deal.messages_disabled
    )
  end

  private

  def render_actions(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/actions', locals: { deal: deal })
  end

  def render_info(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/info', locals: { deal: deal })
  end

end
