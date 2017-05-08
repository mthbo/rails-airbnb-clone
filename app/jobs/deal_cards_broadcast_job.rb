class DealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.advisor
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{deal.advisor.id}:cards",
        card: render_deal_card(deal, deal.advisor, deal.advisor.locale),
        general_status: deal.general_status,
      )
      ActionCable.server.broadcast(
        "user_#{deal.advisor.id}:notifications",
        notifications: render_user_notifications(deal.advisor)
      )
    end

    if deal.client
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{deal.client.id}:cards",
        card: render_deal_card(deal, deal.client, deal.client.locale),
        general_status: deal.general_status,
      )
      ActionCable.server.broadcast(
        "user_#{deal.client.id}:notifications",
        notifications: render_user_notifications(deal.client)
      )
    end
  end

  private

  def render_deal_card(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
    end
  end

  def render_user_notifications(receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'users/notifications')
  end
end
