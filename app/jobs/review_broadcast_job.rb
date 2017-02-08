class ReviewBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    ActionCable.server.broadcast(
      "deal_#{deal.id}_user_#{receiver.id}:status",
      info: render_info(deal, receiver),
      actions: render_actions(deal, receiver),
      reviews: render_reviews(deal, receiver)
    )
  end

  private

  def render_info(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/info', locals: { deal: deal })
  end

  def render_actions(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/actions', locals: { deal: deal })
  end

  def render_reviews(deal, receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/reviews', locals: { deal: deal })
  end
end
