class AddRoomNameToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :room_name, :string
  end
end
