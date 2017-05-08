class AddPayoutsAuthorizedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :payout_authorized, :boolean, null: false, default: false
  end
end
