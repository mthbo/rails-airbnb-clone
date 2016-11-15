class CreateOfferMeans < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_means do |t|
      t.references :mean, foreign_key: true
      t.references :offer, foreign_key: true

      t.timestamps
    end
  end
end
