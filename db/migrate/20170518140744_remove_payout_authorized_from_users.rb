class RemovePayoutAuthorizedFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :pricing_authorized
  end
end
