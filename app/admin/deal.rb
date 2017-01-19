ActiveAdmin.register Deal do

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
    column :offer
    column :advisor do |deal|
      link_to deal.advisor.id, admin_user_path(deal.advisor)
    end
    column :client do |deal|
      link_to deal.client_id, admin_user_path(deal.client)
    end
    column :status
    column :amount
    column :objectives_count
    column :client_global_rating do |deal|
      "#{(deal.client_global_rating.fdiv(5) * 100).to_i} %" unless deal.client_global_rating.nil?
    end
    column :advisor_global_rating do |deal|
      "#{(deal.advisor_global_rating.fdiv(5) * 100).to_i} %" unless deal.advisor_global_rating.nil?
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :advisor
      row :client
      row :status
      row :deadline
      row :amount
      row :payment
    end
    attributes_table do
      row :created_at
      row :request
      row :proposition_at
      row :proposition_deadline
      row :proposition
      row :objectives do |deal|
        deal.objectives.map { |o| o.description }.join("\n")
      end
      row :languages do |deal|
        deal.languages.map { |l| l.name }.join(", ")
      end
      row :means do |deal|
        deal.means.map { |m| m.name }.join(", ")
      end
      row :accepted_at
      row :closed_at
    end
    attributes_table do
      row :client_review
      row :client_rating
      row :client_review_at
      row :advisor_review
      row :advisor_review_at
      row :advisor_rating
      row :client_global_rating do |deal|
        "#{(deal.client_global_rating.fdiv(5) * 100).to_i} %" unless deal.client_global_rating.nil?
      end
      row :advisor_global_rating do |deal|
        "#{(deal.advisor_global_rating.fdiv(5) * 100).to_i} %" unless deal.advisor_global_rating.nil?
      end
    end
    attributes_table do
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Deal summary" do
      f.input :offer_id
      f.input :client_id
      f.input :status
      f.input :deadline
      f.input :amount
    end
    f.inputs "Deal details" do
      f.input :request
      f.input :proposition_at
      f.input :proposition_deadline
      f.input :proposition
      f.input :objectives
      f.input :languages, as: :check_boxes
      f.input :means, as: :check_boxes
      f.input :accepted_at
      f.input :closed_at
      f.input :client_review
      f.input :client_rating
      f.input :client_review_at
      f.input :advisor_review
      f.input :advisor_review_at
      f.input :advisor_rating
    end
    f.actions
  end

  permit_params(
    :offer_id,
    :client_id,
    :request,
    :status,
    :deadline,
    :amount,
    :proposition,
    :proposition_at,
    :accepted_at,
    :closed_at,
    :proposition_deadline,
    :client_review,
    :client_review_at,
    :client_rating,
    :advisor_review,
    :advisor_review_at,
    :advisor_rating,
    mean_ids: [],
    language_ids: []
  )

end
