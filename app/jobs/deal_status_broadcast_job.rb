class DealStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(deal, receiver)
    if receiver
      ActionCable.server.broadcast(
        "deal_#{deal.id}_user_#{receiver.id}:status",
        status: render_status(deal, receiver, receiver.locale),
        info: render_info(deal, receiver, receiver.locale),
        actions: render_actions(deal, receiver, receiver.locale),
        messages_disabled: deal.messages_disabled
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
