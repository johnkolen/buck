class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.integer :user_id
      t.string :encrypted_password
      t.string :salt
      t.timestamps
    end
  end
end
