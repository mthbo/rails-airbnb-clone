class ApplicationMailer < ActionMailer::Base
  default from: %(Papoters <#{ENV['EMAIL_CONTACT']}>)
  layout 'mailer'
end
