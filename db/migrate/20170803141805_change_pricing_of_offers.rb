class ChangePricingOfOffers < ActiveRecord::Migration[5.0]
  def change
    change_column :offers, :pricing, :integer, default: 1
  end
end
