class CreateAdditionalOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :additional_owners do |t|
      t.references :user, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :birth_date
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country_code

      t.timestamps
    end
  end
end
