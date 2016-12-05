class AddAmountToDeals < ActiveRecord::Migration[5.0]
  def change
    add_monetize :deals, :amount, currency: { present: false }
    add_column :deals, :payment, :json
    add_column :deals, :status, :integer, default: 0
  end
end
