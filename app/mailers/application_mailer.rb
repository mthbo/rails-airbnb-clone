class ApplicationMailer < ActionMailer::Base
  default from: %("Papoters" <mathieu.bordeleau@papoters.com>)
  layout 'mailer'
end
