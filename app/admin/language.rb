ActiveAdmin.register Language do

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
    column :name
    column :code
    column :offers_count
    column :deals_count
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :offers_count
      row :deals_count
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Language details" do
      f.input :name
      f.input :code
    end
    f.actions
  end

  permit_params :name, :code

end
