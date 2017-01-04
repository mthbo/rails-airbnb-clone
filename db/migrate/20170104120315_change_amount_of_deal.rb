class ChangeAmountOfDeal < ActiveRecord::Migration[5.0]
  def change
    change_column :deals, :amount_cents, :integer, null: true, default: nil
  end
end
