class RemoveColumnsToDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :client_rating
    remove_column :deals, :advisor_rating
  end
end
