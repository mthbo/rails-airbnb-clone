module DealOpening
  extend ActiveSupport::Concern

  def open_deal
    @deal.opened!
    @deal.opened_at = DateTime.current.in_time_zone
    @deal.increment_notifications(@deal.advisor)
    @deal.reset_notifications(@deal.client)
    @deal.save
    Message.create_status_message(@deal, current_user)
    DealStatusBroadcastJob.perform_later(@deal, @deal.advisor)
    DealCardsBroadcastJob.perform_later(@deal)
    DealExpiryJob.set(wait_until: @deal.deadline.end_of_day).perform_later(@deal)
    DealMailer.deal_proposition_accepted_advisor(@deal).deliver_later
    DealMailer.deal_proposition_accepted_client(@deal).deliver_later
    DealMailer.deal_payment_receipt(@deal).deliver_later if @deal.paid?
    respond_to do |format|
      format.html {
        flash[:notice] = t('deals.accept_proposition.notice', id: @deal.id, name: @deal.advisor.first_name)
        redirect_to deal_path(@deal)
      }
      format.js
    end
  end

end
