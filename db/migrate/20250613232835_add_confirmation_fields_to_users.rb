class AddConfirmationFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirmed, :boolean, default: false, null: false
    add_column :users, :confirmation_token, :string
    add_index :users, :confirmation_token, unique: true
  end
end
