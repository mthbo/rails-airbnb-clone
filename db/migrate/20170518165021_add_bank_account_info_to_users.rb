class AddBankAccountInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bank_name, :string
    add_column :users, :bank_last4, :string
  end
end
