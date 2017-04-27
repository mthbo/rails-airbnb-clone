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
      row :email
      row :first_name
      row :last_name
      row :bio
      row :age
      row :phone_number
      row :address
      row :zip_code
      row :city
      row :country
      row :locale
      row :admin
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
      row :provider
      row :uid
      row :facebook_picture_url
      row :token
      row :token_expiry
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Identity" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :bio
      f.input :birth_date
      f.input :phone_number
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :country_code
      f.input :locale
    end
    f.inputs "Admin" do
      f.input :admin
      f.input :confirmed_at
    end
    f.actions
  end

  permit_params :email, :phone_number, :first_name, :last_name, :address, :bio, :birth_date, :zip_code, :city, :country_code, :locale, :admin, :confirmed_at

end
