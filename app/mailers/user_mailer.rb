class UserMailer < ApplicationMailer
  default from: %(Papoters <#{ENV['EMAIL_CONTACT']}>)
  add_template_helper(TextHelper)

  def pricing_pending(advisor)
    @advisor = advisor
    I18n.with_locale(advisor.locale.to_sym) do
      mail(to: advisor.email, subject: t('user_mailer.pricing_pending.subject'))
    end
  end
end
