# This migration comes from kiqr (originally 20240325142603)
class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :public_uid, index: { unique: true }

      t.references :user, null: true, foreign_key: true # nullable for invitations
      t.references :account, null: false, foreign_key: true
      t.references :invited_by, foreign_key: { to_table: :members }, null: true # null for owner

      ## Is the user an owner of the account?
      t.boolean :owner, default: false, null: false

      ## Invitations fields
      t.string :invitation_email
      t.string :invitation_token
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at

      t.timestamps
    end

    add_index :members, :invitation_token, unique: true
    add_index :members, [ :account_id, :user_id ], unique: true
    add_index :members, [ :account_id, :invitation_email ], unique: true
  end
end
