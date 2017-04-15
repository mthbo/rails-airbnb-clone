class DealMailer < ApplicationMailer

  add_template_helper(TextHelper)

  def deal_request(deal)
    @deal = deal
    mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_request.subject', id: @deal.id))
  end

  def deal_proposition(deal)
    @deal = deal
    mail(to: @deal.client.email, subject: t('deal_mailer.deal_proposition.subject', id: @deal.id))
  end

  def deal_proposition_declined(deal)
    @deal = deal
    mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_declined.subject', id: @deal.id))
  end

  def deal_proposition_accepted(deal)
    @deal = deal
    mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_accepted.subject', id: @deal.id))
  end

  def deal_proposition_expired_advisor(deal)
    @deal = deal
    mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_expired_advisor.subject', id: @deal.id))
  end

  def deal_proposition_expired_client(deal)
    @deal = deal
    mail(to: @deal.client.email, subject: t('deal_mailer.deal_proposition_expired_client.subject', id: @deal.id))
  end
end
