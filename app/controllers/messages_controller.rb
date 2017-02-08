class MessagesController < ApplicationController
  before_action :find_deal, only: [:create, :type]
  skip_after_action :verify_authorized, only: [:type]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      if @message.user == @deal.advisor
        @deal.client_notifications += 1
        receiver = @deal.client
      elsif @message.user == @deal.client
        @deal.advisor_notifications += 1
        receiver = @deal.advisor
      end
      @deal.save(validate: false)
      MessageNotificationsBroadcastJob.perform_later(@deal, receiver)
      respond_to do |format|
        format.js
      end
    end
  end

  def type
    deal_id = @deal.id
    state = params[:state]
    user_id = current_user.id
    TypingBroadcastJob.perform_later(deal_id, user_id, state)
    @message = Message.new
  end

  private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
