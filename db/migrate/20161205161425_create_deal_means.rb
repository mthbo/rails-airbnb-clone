class CreateDealMeans < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_means do |t|
      t.references :deal, foreign_key: true
      t.references :mean, foreign_key: true

      t.timestamps
    end
  end
end
