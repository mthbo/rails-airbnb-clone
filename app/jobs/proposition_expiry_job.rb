class PropositionExpiryJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.proposition? && (deal.proposition_deadline.end_of_day <= DateTime.current.in_time_zone)
      deal.status = "proposition_declined"
      deal.client_notifications += 1
      deal.advisor_notifications += 1
      deal.save(validate: false)
      DealStatusBroadcastJob.perform_later(deal, deal.client)
      DealStatusBroadcastJob.perform_later(deal, deal.advisor)
      DealCardsBroadcastJob.perform_later(deal)
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
