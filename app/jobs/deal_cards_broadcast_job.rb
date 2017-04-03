class DealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    I18n.available_locales.each do |locale|
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{deal.advisor.id}:cards_#{locale}",
        card: render_deal_card(deal, deal.advisor, locale),
        general_status: deal.general_status,
      )
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{deal.client.id}:cards_#{locale}",
        card: render_deal_card(deal, deal.client, locale),
        general_status: deal.general_status,
      )
    end
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

  def render_deal_card(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal })
    end
  end

  def render_user_notifications(receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'users/notifications')
  end
end
