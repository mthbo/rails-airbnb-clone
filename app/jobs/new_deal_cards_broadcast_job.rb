class NewDealCardsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.advisor
      ActionCable.server.broadcast(
        "new_deal_user_#{deal.advisor.id}:cards",
        card: render_deal_card(deal, deal.advisor, deal.advisor.locale),
        deal_id: deal.id
      )
      ActionCable.server.broadcast(
        "user_#{deal.advisor.id}:notifications",
        notifications: render_user_notifications(deal.advisor)
      )
    end

    if deal.client
      ActionCable.server.broadcast(
        "new_deal_user_#{deal.client.id}:cards",
        card: render_deal_card(deal, deal.client, deal.client.locale),
        deal_id: deal.id
      )
    end
  end

  private

  def render_deal_card(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/card', locals: { deal: deal, locale: locale})
    end
  end

  def render_user_notifications(receiver)
    ApplicationController.render_with_signed_in_user(receiver, partial: 'users/notifications')
  end
end
