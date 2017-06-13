class RenamePayoutAuthorizedOfUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :payout_authorized, :pricing_authorized
  end
end
