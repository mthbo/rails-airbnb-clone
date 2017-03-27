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
    column :pin_count
    column :deals_ongoing_count
    column :deals_closed_count
    column :satisfaction do |offer|
      "#{(offer.satisfaction.fdiv(5) * 100).to_i} %" unless offer.satisfaction.nil?
    end
    column :median_amount
    actions
  end

  show do
    attributes_table do
      row :id
      row :advisor
      row :status
      row :pricing
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
        offer.deals.map { |d| link_to d.id, admin_deal_path(d) }.join(" | ").html_safe
      end
      row :satisfaction do |offer|
        "#{(offer.satisfaction.fdiv(5) * 100).to_i} %" unless offer.satisfaction.nil?
      end
      row :min_amount_money
      row :median_amount_money
      row :max_amount_money
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Offer details" do
      f.input :advisor_id
      f.input :title
      f.input :description
      f.input :status
      f.input :pricing
      f.input :means, as: :check_boxes
      f.input :languages, as: :check_boxes
    end
    f.actions
  end

  permit_params :advisor_id, :title, :description, :status, :pricing, mean_ids: [], language_ids: []

end
