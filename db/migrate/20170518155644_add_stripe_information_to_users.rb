class AddStripeInformationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :legal_type, :integer, default: 0
    add_column :users, :business_name, :string
    add_column :users, :business_tax_id, :string
    add_column :users, :personal_address, :string
    add_column :users, :personal_city, :string
    add_column :users, :personal_zip_code, :string
    add_column :users, :personal_state, :string
  end
end
