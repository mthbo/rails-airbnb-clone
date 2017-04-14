class DealMailer < ApplicationMailer

  def deal_request(deal)
    @deal = deal
    mail(to: @deal.client.email, subject: t('deal_mailer.request.subject', id: @deal.id))
  end
end
