class AddInvitationsFieldsToMembers < ActiveRecord::Migration[7.2]
  def change
    add_column :members, :invitation_email, :string
    add_column :members, :invitation_token, :string
    add_column :members, :invitation_sent_at, :datetime
    add_column :members, :invitation_accepted_at, :datetime

    # Make user_id nullable
    change_column_null :members, :user_id, true

    add_reference :members, :invited_by, foreign_key: { to_table: :members }, null: true
    add_index     :members, [ :account_id, :invitation_email ], unique: true
    add_index     :members, [ :account_id, :invitation_token ], unique: true
  end
end
