class AddDisableMessagesToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :messages_disabled, :boolean, null: false, default: false
  end
end
