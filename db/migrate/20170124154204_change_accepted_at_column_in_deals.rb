class ChangeAcceptedAtColumnInDeals < ActiveRecord::Migration[5.0]
  def change
    rename_column :deals, :accepted_at, :open_at
  end
end
