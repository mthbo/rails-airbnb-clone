class AddTargetToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :target, :integer, default: 0
  end
end
