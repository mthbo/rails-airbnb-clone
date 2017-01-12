class MessagesController < ApplicationController
  before_action :find_deal, only: [:create]

  def create
    @message = @deal.messages.new(message_params)
    @message.user = current_user
    authorize @message
    if @message.save
      # do some stuff
    else
      redirect_to deal_path(@deal)
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
