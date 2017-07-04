class ContactMessageMailer < ApplicationMailer
  default to: ENV['CONTACT_EMAIL']
  layout 'mailer_simple'

  add_template_helper(TextHelper)

  def contact_us(email, subject, body, user_id)
    @message_body = body
    mail(from: email, subject: "Papoters #{user_id.present? ? user_id : nil} | #{subject}")
  end

end
