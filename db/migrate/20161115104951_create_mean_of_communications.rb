class CreateMeanOfCommunications < ActiveRecord::Migration[5.0]
  def change
    create_table :mean_of_communications do |t|
      t.string :name

      t.timestamps
    end
  end
end
