module StripeAccount
  extend ActiveSupport::Concern

  def create_stripe_account
    @account = Stripe::Account.create({
      country: @user.country_code,
      type: 'custom',
      metadata: {
        internal_id: @user.id
      },
      payout_schedule: {
        interval: "manual"
      },
      tos_acceptance: {
        ip: request.remote_ip,
        date: DateTime.now.to_i
      }
    })
    @user.stripe_account_id = @account.id
    @user.save
    update_stripe_account
  end

  def update_stripe_account
    edit_legal_entity
    edit_business if @user.legal_type == "company"
    @account.save
  end

  def update_stripe_bank
    if params[:user][:stripeToken].present?
      @account.external_account = params[:user][:stripeToken]
      @account.save
      status = @account.external_accounts.first.status
      unless status == "verification_failed" || "errored"
        @user.bank_valid!
        @user.advisor_deals_payout_failed.each do |deal|
          deal.payout_pending!
          StripePayoutJob.perform_later(deal)
        end
      end
    end
  end

  private

  def edit_legal_entity
    @account.legal_entity.type = @user.legal_type
    @account.legal_entity.first_name = @user.first_name
    @account.legal_entity.last_name = @user.last_name
    @account.legal_entity.dob.day = @user.birth_date.day
    @account.legal_entity.dob.month = @user.birth_date.month
    @account.legal_entity.dob.year = @user.birth_date.year
    @account.legal_entity.address.line1 = @user.address
    @account.legal_entity.address.postal_code = @user.zip_code
    @account.legal_entity.address.city = @user.city
  end

  def edit_business
    @account.legal_entity.business_name = @user.business_name
    @account.legal_entity.business_tax_id = @user.business_tax_id
    @account.legal_entity.personal_address.line1 = @user.personal_address
    @account.legal_entity.personal_address.postal_code = @user.personal_zip_code
    @account.legal_entity.personal_address.city = @user.personal_city
    @account.legal_entity.personal_address.city = @user.personal_city
    @account.legal_entity.additional_owners = nil if @user.additional_owners.blank?
  end
end
