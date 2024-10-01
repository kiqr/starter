class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      
      t.string :name
      t.string :avatar_type, default: "initials"

      t.timestamps
    end
  end
end
