class DealExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.open? && (deal.deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.status = "open_expired"
      deal.save(validate: false)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      send_status_message(deal)
    end
  end

  private

  def send_status_message(deal)
    message = Message.new(deal: deal, user: deal.advisor, target: "deal_status")
    message.build_deal_status_content
    message.save
  end

end
