class CreateMeans < ActiveRecord::Migration[5.0]
  def change
    create_table :means do |t|
      t.string :name

      t.timestamps
    end
  end
end
