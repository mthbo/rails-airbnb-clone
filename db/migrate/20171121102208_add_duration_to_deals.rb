class AddDurationToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :duration, :integer, default: 30
  end
end
