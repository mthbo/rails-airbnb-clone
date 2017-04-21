class ChangeOpenAtOfDeals < ActiveRecord::Migration[5.0]
  def change
    rename_column :deals, :open_at, :opened_at
  end
end
