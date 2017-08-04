class RemoveNewFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :new
  end
end
