class CreateDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :deals do |t|
      t.references :offer, foreign_key: true
      t.text :request
      t.datetime :deadline
      t.float :price
      t.text :proposition
      t.text :client_review
      t.text :advisor_review
      t.integer :client_rating
      t.integer :advisor_rating
      t.datetime :proposition_at
      t.datetime :accepted_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
