# This migration comes from kiqr (originally 20240325084418)
class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :public_uid, index: { unique: true }
      t.string :name, null: false
      t.boolean :personal, null: false, default: false

      t.timestamps
    end

    # Add a optional personal_account reference to users.
    add_reference :users, :personal_account, foreign_key: { to_table: :accounts }, null: true
  end
end
