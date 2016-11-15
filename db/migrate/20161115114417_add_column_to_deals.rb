class AddColumnToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :client_id, :integer, index: true
    add_foreign_key :deals, :users, column: :client_id
  end
end
