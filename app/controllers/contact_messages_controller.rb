class ContactMessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_after_action :verify_authorized
  layout 'client_form', only: [:new, :create]

  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new message_params

    if @contact_message.valid?
      ContactMessageMailer.contact_us(@contact_message.email, @contact_message.subject, @contact_message.body, @contact_message.user_id).deliver_later
      flash[:notice] = t('.notice')
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(:subject, :email, :body, :user_id)
  end
end
