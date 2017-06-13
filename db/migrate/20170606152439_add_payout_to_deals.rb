class AddPayoutToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :payout, :json
  end
end
