class RemoveFreeDealsFromOffers < ActiveRecord::Migration[5.0]
  def change
    remove_column :offers, :free_deals
  end
end
