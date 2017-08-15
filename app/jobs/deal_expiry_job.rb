class DealExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.opened? && (deal.deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.status = "open_expired"
      deal.increment_notifications(deal.advisor)
      deal.increment_notifications(deal.client)
      deal.save(validate: false)
      Message.create_status_message(deal, deal.advisor)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      DealCardsBroadcastJob.perform_later(deal)
      DealMailer.deal_expired_advisor(deal).deliver_later
      DealMailer.deal_expired_client(deal).deliver_later
      DealAutomaticCloseJob.set(wait_until: deal.automatic_closed_at).perform_later(deal)
    end
  end

end
