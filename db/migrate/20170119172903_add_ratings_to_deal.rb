class AddRatingsToDeal < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :advisor_rating, :integer
    add_column :deals, :client_rating, :integer
  end
end
