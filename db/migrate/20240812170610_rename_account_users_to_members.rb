class RenameAccountUsersToMembers < ActiveRecord::Migration[7.2]
  def change
    rename_table :account_users, :members
  end
end
