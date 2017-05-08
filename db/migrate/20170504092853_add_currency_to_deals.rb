class AddCurrencyToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :currency_code, :string
  end
end
