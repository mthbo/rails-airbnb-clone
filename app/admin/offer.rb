ActiveAdmin.register Offer do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
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
    column :advisor do |offer|
      link_to offer.advisor_id, admin_user_path(offer.advisor)
    end
    column :title
    column :status
    column :pricing
    column :free_deals
    column :pin_count
    column :deals_ongoing_count
    column :deals_closed_count
    column :satisfaction do |offer|
      "#{(offer.satisfaction.fdiv(5) * 100).to_i} %" unless offer.satisfaction.nil?
    end
    column :min_amount_converted
    column :median_amount_converted
    column :max_amount_converted
    actions
  end

  show do
    attributes_table do
      row :id
      row :advisor
      row :status
      row :pricing
      row :free_deals
      row :title
      row :description
      row :languages do |offer|
        offer.languages.map { |l| l.name }.join(", ")
      end
      row :means do |offer|
        offer.means.map { |l| l.name }.join(", ")
      end
      row :created_at
      row :updated_at
    end
    attributes_table do
      row :pin_count
      row :deals_pending_count
      row :deals_open_count
      row :deals_closed_count
      row :deals do |offer|
        offer.deals.map { |d| link_to "#session-#{d.id} | #{d.title}", admin_deal_path(d) }.join("<br>").html_safe
      end
      row :satisfaction do |offer|
        "#{(offer.satisfaction.fdiv(5) * 100).to_i} %" unless offer.satisfaction.nil?
      end
      row :min_amount_converted
      row :median_amount_converted
      row :max_amount_converted
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Offer details" do
      f.input :status
      f.input :pricing
      f.input :free_deals
    end
    f.actions
  end

  permit_params :status, :pricing, :free_deals

end
