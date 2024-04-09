class ReplaceRoleWithOwnerOnAccountUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :account_users, :role, :string, default: "owner", null: false
    add_column :account_users, :owner, :boolean, default: false, null: false
  end
end
