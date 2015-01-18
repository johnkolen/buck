class AddRefreshTokentoVenmoUsers < ActiveRecord::Migration
  def change
    add_column :venmo_users, :refresh_token, :string
  end
end
