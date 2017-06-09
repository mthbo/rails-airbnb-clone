class AddBankStatusToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bank_status, :integer, default: 0
  end
end
