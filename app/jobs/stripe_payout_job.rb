class StripePayoutJob < ApplicationJob
  queue_as :default

  def perform(deal)
    if deal.present? && deal.advisor.present?
      Stripe::Payout.create(
        {
          amount: deal.advisor_amount_converted(deal.advisor.currency).cents,
          currency: deal.advisor_amount_converted(deal.advisor.currency).currency.to_s,
          statement_descriptor: "PAPOTERS",
          metadata: { deal_id: deal.id }
        },
        {stripe_account: deal.advisor.stripe_account_id},
      )
    end
  end

end
