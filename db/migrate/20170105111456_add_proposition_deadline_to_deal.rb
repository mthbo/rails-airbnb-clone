class AddPropositionDeadlineToDeal < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :proposition_deadline, :datetime
  end
end
