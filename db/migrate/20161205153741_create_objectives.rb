class CreateObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :objectives do |t|
      t.text :description
      t.integer :rating
      t.references :deal, foreign_key: true

      t.timestamps
    end
  end
end
