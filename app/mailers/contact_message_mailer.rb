class ContactMessageMailer < ApplicationMailer
  default to: ENV['EMAIL_CONTACT']
  layout 'mailer_simple'

  add_template_helper(TextHelper)

  def contact_us(email, subject, body, user_id)
    @message_body = body
    mail(reply_to: email, subject: "Papoters #{user_id.present? ? user_id : nil} | #{subject}")
  end

end
