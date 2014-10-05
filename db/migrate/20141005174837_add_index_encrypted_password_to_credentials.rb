class AddIndexEncryptedPasswordToCredentials < ActiveRecord::Migration
  def change
    add_index :credentials, :encrypted_password
  end
end
