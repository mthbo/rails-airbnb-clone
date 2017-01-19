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
    column :global_rating do |offer|
      "#{(offer.global_rating / 5 * 100).to_i} %" unless offer.global_rating.nil?
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
    end
    attributes_table do
      row :pin_count
      row :deals_pending_count
      row :deals_open_count
      row :deals_closed_count
      row :global_rating do |offer|
        "#{(offer.global_rating / 5 * 100).to_i} %" unless offer.global_rating.nil?
      end
      row :min_amount
      row :median_amount
      row :max_amount
    end
    attributes_table do
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Offer details" do
      f.input :title
      f.input :description
      f.input :status
      f.input :pricing
      f.input :means, as: :check_boxes
      f.input :languages, as: :check_boxes
    end
    f.actions
  end

  permit_params :title, :description, :status, :pricing, mean_ids: [], language_ids: []

end
