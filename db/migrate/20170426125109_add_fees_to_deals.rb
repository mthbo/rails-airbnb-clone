class AddFeesToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :fees_cents, :integer, null: true, default: nil
  end
end
