class MessagesController < ApplicationController
  include Receiver
  before_action :find_deal, only: [:create]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      set_receiver
      @deal.increment_notifications(@receiver)
      @deal.reset_notifications(current_user)
      @deal.save(validate: false)
      DealNotificationsBroadcastJob.perform_later(@deal)
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
