class AddTemporaryToCredentials < ActiveRecord::Migration
  def change
    add_column :credentials, :temporary, :boolean, :default=>false
    add_column :credentials, :expires_at, :datetime
  end
end
