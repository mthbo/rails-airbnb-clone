class ChangeStripeIdOfUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :stripe_id, :stripe_customer_id
  end
end
