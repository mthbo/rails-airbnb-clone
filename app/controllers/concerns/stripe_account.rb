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
    edit_account
    edit_legal_entity
    edit_external_account if params[:user][:stripeToken].present?
    edit_business if @user.legal_type == "company"
    @account.save
  end

  private

  def edit_account
    @account.email = @user.email
  end

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

  def edit_external_account
    @account.external_account = params[:user][:stripeToken]
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
