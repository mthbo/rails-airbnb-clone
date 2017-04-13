class ApplicationMailer < ActionMailer::Base
  default from: %("Caca" <mathieu.bordeleau@papoters.com>)
  layout 'mailer'
end
