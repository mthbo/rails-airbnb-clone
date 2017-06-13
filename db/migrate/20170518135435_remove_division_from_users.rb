class RemoveDivisionFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :division, :string
  end
end
