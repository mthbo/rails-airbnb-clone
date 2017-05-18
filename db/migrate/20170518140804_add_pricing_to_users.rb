class AddPricingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pricing, :integer, default: 0
  end
end
