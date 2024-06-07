class AddPublicUidToAccountUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :account_users, :public_uid, :string
    add_index :account_users, :public_uid, unique: true
  end
end
