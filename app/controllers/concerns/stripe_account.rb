module StripeAccount
  extend ActiveSupport::Concern

  def create_account
    @account = Stripe::Account.create({
      country: @user.country_code,
      managed: true,
      external_account: params[:user][:stripeToken],
      tos_acceptance: {
        ip: request.remote_ip,
        date: DateTime.now.to_i
      },
      legal_entity: {
        type: @user.legal_type,
        first_name: @user.first_name,
        last_name: @user.last_name,
        dob: {
          day: @user.birth_date.day,
          month: @user.birth_date.month,
          year: @user.birth_date.year,
        },
        address: {
          line1: @user.address,
          postal_code: @user.zip_code,
          city: @user.city
        }
      }
    })
    if @account.legal_entity.type == "company"
      @account.legal_entity.business_name = @user.business_name
      @account.legal_entity.business_tax_id = @user.business_tax_id
      @account.legal_entity.personal_address.line1 = @user.personal_address
      @account.legal_entity.personal_address.postal_code = @user.personal_zip_code
      @account.legal_entity.personal_address.city = @user.personal_city
      @account.save
    end
    @user.stripe_account_id = @account.id
    @user.pricing_enabled! if (@account.payouts_enabled && @account.charges_enabled)
    @user.save
  end

  def update_account
  end

  def delete_account
  end
end
