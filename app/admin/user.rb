ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    column :id
    column :email
    column :first_name
    column :last_name
    column :age
    column :city
    column :country_code
    column :locale
    column :pricing
    column :legal_type
    column :bank_status
    column :verified
    column :sign_in_count
    column :offers_active_count
    column :offers_priced_count
    column :client_deals_closed_count
    column :client_deals_ongoing_count
    column :advisor_deals_closed_count
    column :advisor_deals_ongoing_count
    column :admin
    actions
  end

  show do
    attributes_table do
      row :id
      row :admin
      row :email
      row :locale
      row :first_name
      row :last_name
      row :bio
      row :age
      row :photo
      row :phone_number
      row :country
      row :address
      row :zip_code
      row :city
      row :state
      row :latitude
      row :longitude
    end
    attributes_table do
      row :pricing
      row :legal_type
      row :verified
      row :stripe_customer_id
      row :stripe_account_id
      row :currency_code
      row :disabled_reason
      row :disabled_reason_category
      row :verification_status
      row :identity_document_name
      row :business_name
      row :business_tax_id
      row :personal_address
      row :personal_zip_code
      row :personal_city
      row :personal_state
      row :bank_status
      row :bank_name
      row :bank_last4
    end
    attributes_table do
      row :grade
      row :offers_active_count
      row :offers_inactive_count
      row :offers_priced_count
      row :offers do |user|
        user.offers.map { |o| link_to "#{o.id} | #{o.title}", admin_offer_path(o) }.join("<br>").html_safe
      end
      row :client_deals_pending_count
      row :client_deals_open_count
      row :client_deals_closed_count
      row :client_deals do |user|
        user.client_deals.map { |d| link_to "#session-#{d.id} | #{d.title}", admin_deal_path(d) }.join("<br>").html_safe
      end
      row :advisor_deals_pending_count
      row :advisor_deals_open_count
      row :advisor_deals_closed_count
      row :advisor_deals_payout_failed_counts
      row :advisor_deals do |user|
        user.advisor_deals.map { |d| link_to "#session-#{d.id} | #{d.title}", admin_deal_path(d) }.join("<br>").html_safe
      end
    end
    attributes_table do
      row :created_at
      row :confirmed_at
      row :confirmation_token
      row :confirmation_sent_at
      row :updated_at
      row :sign_in_count
      row :remember_created_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
    end
    attributes_table do
      row :provider
      row :uid
      row :facebook_picture_url
      row :token
      row :token_expiry
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "User" do
      f.input :admin
      f.input :confirmed_at
      f.input :country_code
      f.input :currency_code
      f.input :pricing
      f.input :bank_status
    end
    f.actions
  end

  permit_params :admin, :confirmed_at, :country_code, :currency_code, :pricing, :bank_status

end
