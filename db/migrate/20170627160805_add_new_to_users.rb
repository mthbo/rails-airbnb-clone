class AddNewToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :new, :boolean, null: false, default: true
  end
end
