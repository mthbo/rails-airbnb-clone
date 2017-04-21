class DealExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.opened? && (deal.deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.status = "open_expired"
      deal.client_notifications += 1
      deal.advisor_notifications += 1
      deal.save(validate: false)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      DealCardsBroadcastJob.perform_later(deal)
      send_status_message(deal)
      DealMailer.deal_expired_advisor(deal).deliver_later
      DealMailer.deal_expired_client(deal).deliver_later
    end
  end

  private

  def send_status_message(deal)
    message = Message.new(deal: deal, user: deal.advisor, target: "deal_status")
    message.build_deal_status_content
    message.save
  end

end
