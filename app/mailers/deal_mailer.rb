class DealMailer < ApplicationMailer

  add_template_helper(TextHelper)

  def deal_request(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_request.subject', id: @deal.id))
    end
  end

  def deal_proposition(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_proposition.subject', id: @deal.id))
    end
  end

  def deal_proposition_declined(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_declined.subject', id: @deal.id))
    end
  end

  def deal_proposition_accepted(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_accepted.subject', id: @deal.id))
    end
  end

  def deal_proposition_expired_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_expired_advisor.subject', id: @deal.id))
    end
  end

  def deal_proposition_expired_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_proposition_expired_client.subject', id: @deal.id))
    end
  end
end
