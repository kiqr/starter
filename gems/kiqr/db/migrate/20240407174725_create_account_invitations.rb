class CreateAccountInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :account_invitations do |t|
      t.string :public_uid, index: {unique: true}
      t.references :account, null: false, foreign_key: true
      t.string :email, null: false
      t.datetime :accepted_at
      t.timestamps
    end

    add_column :accounts, :account_invitations_count, :integer, default: 0
    add_index :account_invitations, :email
    add_index :account_invitations, [:account_id, :email], unique: true
  end
end
