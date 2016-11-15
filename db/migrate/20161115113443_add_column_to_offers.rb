class AddColumnToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :advisor_id, :integer, index: true
    add_foreign_key :offers, :users, column: :advisor_id
  end
end
