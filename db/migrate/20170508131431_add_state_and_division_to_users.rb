class AddStateAndDivisionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :state, :string
    add_column :users, :division, :string
  end
end
