class DropAccountInvitationsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :account_invitations
  end
end
