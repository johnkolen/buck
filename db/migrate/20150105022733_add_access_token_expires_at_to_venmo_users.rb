class AddAccessTokenExpiresAtToVenmoUsers < ActiveRecord::Migration
  def change
    add_column :venmo_users, :access_token_expires_at, :datetime
  end
end
