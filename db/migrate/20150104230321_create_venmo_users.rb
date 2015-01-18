class CreateVenmoUsers < ActiveRecord::Migration
  def change
    create_table :venmo_users do |t|
      t.integer :user_id
      t.string :venmo_id
      t.string :access_token
      t.datetime :access_token_updated_at

      t.timestamps
    end
  end
end
