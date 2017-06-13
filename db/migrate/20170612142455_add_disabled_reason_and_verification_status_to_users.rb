class AddDisabledReasonAndVerificationStatusToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :disabled_reason, :string
    add_column :users, :verification_status, :string
  end
end
