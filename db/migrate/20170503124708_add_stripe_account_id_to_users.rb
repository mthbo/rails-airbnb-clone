class AddStripeAccountIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_account_id, :string
  end
end
