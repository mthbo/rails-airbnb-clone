class DealExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.open? && (deal.deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.open_expired!
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      send_status_message(deal)
    end
  end

  private

  def send_status_message(deal)
    message = Message.new(deal: deal, user: deal.client, target: "deal_status")
    message.build_deal_status_content
    message.save
  end

end
