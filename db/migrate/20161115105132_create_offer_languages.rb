class CreateOfferLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_languages do |t|
      t.references :language, foreign_key: true
      t.references :offer, foreign_key: true

      t.timestamps
    end
  end
end
