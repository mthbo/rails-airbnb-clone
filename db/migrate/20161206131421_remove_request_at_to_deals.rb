class RemoveRequestAtToDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :request_at
  end
end
