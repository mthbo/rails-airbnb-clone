class RemovePriceToDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :price
  end
end
