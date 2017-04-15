class AddFreeDealsToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :free_deals, :integer, default: 3
  end
end
