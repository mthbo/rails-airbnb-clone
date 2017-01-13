class MessagesController < ApplicationController
  before_action :find_deal, only: [:create]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      ActionCable.server.broadcast(
        "messages_#{@deal.id}",
        content: @message.content_formatted,
        user_id: @message.user.id,
        created_at: @message.created_at
      )
      head :ok
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
