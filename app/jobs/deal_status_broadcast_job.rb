class DealStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    I18n.available_locales.each do |locale|
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{receiver.id}:status_#{locale}",
        status: render_status(deal, receiver, locale),
        info: render_info(deal, receiver, locale),
        actions: render_actions(deal, receiver, locale)
      )
    end
  end

  private

  def render_status(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/status', locals: { deal: deal })
    end
  end

  def render_info(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/info', locals: { deal: deal })
    end
  end

  def render_actions(deal, receiver, locale)
    I18n.with_locale(locale) do
      ApplicationController.render_with_signed_in_user(receiver, partial: 'deals/actions', locals: { deal: deal })
    end
  end
end
