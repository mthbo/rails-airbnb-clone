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
      row :offer
      row :advisor
      row :client
      row :status
      row :messages_disabled
      row :deadline
      row :amount
      row :payment_state
      row :payment
    end
    attributes_table do
      row :created_at
      row :request
      row :proposition_at
      row :proposition_deadline
      row :proposition
      row :objectives do |deal|
        deal.objectives.each_with_index.map { |o, i| link_to "#{i + 1} | #{o.description}", admin_objective_path(o) }.join("<br>").html_safe
      end
      row :languages do |deal|
        deal.languages.map { |l| l.name }.join(", ")
      end
      row :means do |deal|
        deal.means.map { |m| m.name }.join(", ")
      end
      row :open_at
      row :closed_at
      row :updated_at
    end
    attributes_table do
      row :who_reviews
      row :client_review_at
      row :client_global_rating do |deal|
        "#{(deal.client_global_rating.fdiv(5) * 100).to_i} %" unless deal.client_global_rating.nil?
      end
      row :client_rating
      row :objectives_rating do |deal|
        deal.objectives.map { |o| "#{o.description} : #{o.rating}" }.join("<br>").html_safe
      end
      row :client_review
      row :advisor_review_at
      row :advisor_global_rating do |deal|
        "#{(deal.advisor_global_rating.fdiv(5) * 100).to_i} %" unless deal.advisor_global_rating.nil?
      end
      row :advisor_rating
      row :advisor_review
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Deal summary" do
      f.input :offer_id
      f.input :client_id
      f.input :status
      f.input :payment_state
      f.input :messages_disabled
      f.input :deadline
      f.input :amount
    end
    f.inputs "Deal details" do
      f.input :request
      f.input :proposition_at
      f.input :proposition_deadline
      f.input :proposition
      f.input :languages, as: :check_boxes, collection: deal.offer.languages
      f.input :means, as: :check_boxes, collection: deal.offer.means
      f.input :open_at
      f.input :closed_at
      f.input :who_reviews
      f.input :client_review_at
      f.input :client_rating
      f.input :client_review
      f.input :advisor_review_at
      f.input :advisor_rating
      f.input :advisor_review
    end
    f.actions
  end

  permit_params(
    :offer_id,
    :client_id,
    :request,
    :status,
    :payment_state,
    :messages_disabled,
    :deadline,
    :amount,
    :proposition,
    :proposition_at,
    :open_at,
    :closed_at,
    :proposition_deadline,
    :who_reviews,
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
