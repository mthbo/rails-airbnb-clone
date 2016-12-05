class AddRequestAtToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :request_at, :datetime
  end
end
