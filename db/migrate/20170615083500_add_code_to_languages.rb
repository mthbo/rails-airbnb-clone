class AddCodeToLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :languages, :code, :string
  end
end
