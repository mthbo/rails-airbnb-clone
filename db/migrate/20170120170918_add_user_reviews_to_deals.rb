class AddUserReviewsToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :who_reviews, :integer, default: 0
  end
end
