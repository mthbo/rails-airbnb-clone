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
    column :payment_state
    column :currency_code
    column :amount
    column :fees
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
      row :title
      row :advisor
      row :client
      row :status
      row :messages_disabled
      row :room_name
      row :client_notifications
      row :advisor_notifications
      row :messages_count
    end
    attributes_table do
      row :payment_state
      row :currency_code
      row :amount
      row :advisor_amount
      row :fees
      row :payment
      row :payout
    end
    attributes_table do
      row :created_at
      row :deadline
      row :request
      row :proposition_at
      row :proposition_deadline
      row :proposition
      row :objectives do |deal|
        deal.objectives.each_with_index.map { |o, i| "#{i + 1} | #{o.description}" }.join("<br>").html_safe
      end
      row :languages do |deal|
        deal.languages.map { |l| l.name }.join(", ")
      end
      row :means do |deal|
        deal.means.map { |m| m.name }.join(", ")
      end
      row :opened_at
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
    f.inputs "Deal" do
      f.input :status
      f.input :payment_state
      f.input :room_name
      f.input :messages_disabled
    end
    f.actions
  end

  permit_params( :status, :payment_state, :room_name, :messages_disabled )

end
