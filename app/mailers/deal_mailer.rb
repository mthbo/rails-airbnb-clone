class DealMailer < ApplicationMailer

  add_template_helper(TextHelper)

  def deal_request(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_request.subject', id: @deal.id))
    end
  end

  def deal_request_expired_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_request_expired_advisor.subject', id: @deal.id))
    end
  end

  def deal_request_expired_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_request_expired_client.subject', id: @deal.id))
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

  def deal_proposition_accepted_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_proposition_accepted_advisor.subject', id: @deal.id))
    end
  end

  def deal_proposition_accepted_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_proposition_accepted_client.subject', id: @deal.id))
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

  def deal_expired_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_expired_advisor.subject', id: @deal.id))
    end
  end

  def deal_expired_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_expired_client.subject', id: @deal.id))
    end
  end

  def deal_closed_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_closed_advisor.subject', id: @deal.id))
    end
  end

  def deal_closed_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_closed_client.subject', id: @deal.id))
    end
  end

  def deal_review_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_review_advisor.subject', id: @deal.id))
    end
  end

  def deal_review_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_review_client.subject', id: @deal.id))
    end
  end

  def deal_cancelled_advisor(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_cancelled_advisor.subject', id: @deal.id))
    end
  end

  def deal_cancelled_client(deal)
    @deal = deal
    I18n.with_locale(@deal.client.locale.to_sym) do
      mail(to: @deal.client.email, subject: t('deal_mailer.deal_cancelled_client.subject', id: @deal.id))
    end
  end

  def deal_payout_failed(deal)
    @deal = deal
    I18n.with_locale(@deal.advisor.locale.to_sym) do
      mail(to: @deal.advisor.email, subject: t('deal_mailer.deal_payout_failed.subject', id: @deal.id))
    end
  end

end
