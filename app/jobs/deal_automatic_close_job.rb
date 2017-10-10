class DealAutomaticCloseJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.open_expired? && (deal.automatic_closed_at <= DateTime.current.in_time_zone)
      deal.status = "closed"
      deal.closed_at = DateTime.current.in_time_zone
      deal.increment_notifications(deal.advisor)
      deal.increment_notifications(deal.client)
      deal.save(validate: false)
      if deal.paid?
        deal.payout_pending!
        StripePayoutJob.set(wait_until: deal.payout_triggered_at).perform_later(deal)
      end
      Message.create_status_message(deal, deal.advisor)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      DealCardsBroadcastJob.perform_later(deal)
      DealMailer.deal_closed_client(deal).deliver_later
      DealMailer.deal_closed_advisor(deal).deliver_later
      if deal.advisor.no_pricing? && deal.advisor.free_deals_before_pricing.zero?
        deal.advisor.pricing_pending!
        UserMailer.pricing_pending(deal.advisor).deliver_later if deal.advisor.pricing_available?
      end
      IndexUserOffersJob.perform_later(deal.advisor)
    end
  end

end
