class AddCurrencyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :currency_code, :string, default: "EUR"
  end
end
