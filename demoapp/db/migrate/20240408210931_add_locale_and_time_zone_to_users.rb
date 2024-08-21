class AddLocaleAndTimeZoneToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :locale, :string, default: "en"
    add_column :users, :time_zone, :string, default: "UTC"
  end
end
