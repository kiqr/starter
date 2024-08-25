# This migration comes from kiqr (originally 20240424103325)
class CreateOmniauthIdentities < ActiveRecord::Migration[7.1]
  def change
    create_table :omniauth_identities do |t|
      t.string :public_uid, index: { unique: true }

      t.references :user, foreign_key: true, null: false

      t.string :provider, null: false
      t.string :provider_uid, null: false

      t.text :credentials
      t.text :info
      t.text :extra

      t.datetime :expires_at
      t.timestamps
    end
  end
end
