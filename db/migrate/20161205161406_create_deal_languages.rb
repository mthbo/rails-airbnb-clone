class CreateDealLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_languages do |t|
      t.references :deal, foreign_key: true
      t.references :language, foreign_key: true

      t.timestamps
    end
  end
end
