class AddPaymentStateToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :payment_state, :integer, default: 0
  end
end
