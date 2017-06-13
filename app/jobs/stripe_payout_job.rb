class StripePayoutJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.advisor.present? && deal.advisor.pricing_enabled?
      begin
        payout = Stripe::Payout.create(
          {
            amount: deal.advisor_amount_converted(deal.advisor.currency).cents,
            currency: deal.advisor_amount_converted(deal.advisor.currency).currency.to_s,
            statement_descriptor: "PAPOTERS",
            metadata: { deal_id: deal.id }
          },
          {stripe_account: deal.advisor.stripe_account_id},
        )
        deal.payout = payout.to_json
        deal.save

      rescue Stripe::InvalidRequestError => e
        deal.payout_failed!
        DealMailer.deal_payout_failed(deal).deliver_later

      rescue Stripe::StripeError => e
        StripePayoutJob.set(wait_until: 1.hour.from_now).perform_later(deal)

      end

    else
      deal.payout_failed!
      DealMailer.deal_payout_failed(deal).deliver_later

    end
  end

end
