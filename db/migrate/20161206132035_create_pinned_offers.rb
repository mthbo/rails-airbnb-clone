class CreatePinnedOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :pinned_offers do |t|
      t.references :offer, foreign_key: true
      t.integer :client_id, index: true
      t.timestamps
    end

    add_foreign_key :pinned_offers, :users, column: :client_id
  end
end
