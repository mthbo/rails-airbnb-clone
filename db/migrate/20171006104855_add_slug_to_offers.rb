class AddSlugToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :slug, :string
    add_index :offers, :slug, unique: true
  end
end
