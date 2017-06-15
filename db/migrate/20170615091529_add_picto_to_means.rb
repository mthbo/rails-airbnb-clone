class AddPictoToMeans < ActiveRecord::Migration[5.0]
  def change
    add_column :means, :picto, :string
  end
end
