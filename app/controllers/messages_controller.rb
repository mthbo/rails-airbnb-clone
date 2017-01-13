class MessagesController < ApplicationController
  before_action :find_deal, only: [:create, :type]
  skip_after_action :verify_authorized, only: [:type]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      respond_to do |format|
        format.js
      end
    end
  end

  def type
    deal_id = @deal.id
    user_id = current_user.id
    state = params[:state]
    @message = Message.new
    TypingBroadcastJob.perform_now(deal_id, user_id, state)
  end

  private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
