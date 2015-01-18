class AddDeclinedToVenmoUsers < ActiveRecord::Migration
  def change
    add_column :venmo_users, :declined, :boolean, :default=>false
  end
end
