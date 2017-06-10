class AddPayoutMadeAtToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :payout_made_at, :datetime
  end
end
