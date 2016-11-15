class CreateOfferMeanOfCommunications < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_mean_of_communications do |t|
      t.references :mean_of_communication, foreign_key: true
      t.references :offer, foreign_key: true

      t.timestamps
    end
  end
end
