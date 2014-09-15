class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, :default=>'Central Time (US & Canada)'
  end
end
