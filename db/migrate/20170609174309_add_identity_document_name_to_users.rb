class AddIdentityDocumentNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :identity_document_name, :string
  end
end
