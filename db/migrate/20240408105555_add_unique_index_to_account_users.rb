class AddUniqueIndexToAccountUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :account_users, [ :account_id, :user_id ], unique: true
  end
end
