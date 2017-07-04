class ApplicationMailer < ActionMailer::Base
  default from: %(Papoters <#{ENV['CONTACT_EMAIL']}>)
  layout 'mailer'
end
