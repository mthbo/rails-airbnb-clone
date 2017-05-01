class RequestExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.pending? && (deal.deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.status = "cancelled"
      deal.messages_disabled = true
      deal.payment_state = "no_payment"
      deal.increment_notifications(deal.advisor)
      deal.increment_notifications(deal.client)
      deal.save(validate: false)
      Message.create_status_message(deal, deal.advisor)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      DealCardsBroadcastJob.perform_later(deal)
      DealMailer.deal_request_expired_advisor(deal).deliver_later
      DealMailer.deal_request_expired_client(deal).deliver_later
    end
  end

end
