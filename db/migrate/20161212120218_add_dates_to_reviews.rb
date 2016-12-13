class AddDatesToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :client_review_at, :datetime
    add_column :deals, :advisor_review_at, :datetime
  end
end
