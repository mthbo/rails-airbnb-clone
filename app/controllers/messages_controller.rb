class MessagesController < ApplicationController
  before_action :find_deal, only: [:create]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      if @message.user == @deal.advisor
        @deal.client_notifications += 1
        @deal.advisor_notifications = 0
        receiver = @deal.client
      elsif @message.user == @deal.client
        @deal.advisor_notifications += 1
        @deal.client_notifications = 0
        receiver = @deal.advisor
      end
      @deal.save(validate: false)
      DealNotificationsBroadcastJob.perform_later(@deal)
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
