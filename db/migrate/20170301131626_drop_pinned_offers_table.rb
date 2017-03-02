class DropPinnedOffersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table(:pinned_offers)
  end
end
