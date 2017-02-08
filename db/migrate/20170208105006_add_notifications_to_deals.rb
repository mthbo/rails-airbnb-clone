class AddNotificationsToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :client_notifications, :integer, default: 0
    add_column :deals, :advisor_notifications, :integer, default: 0
  end
end
