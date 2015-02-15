class CreatePaypalUsers < ActiveRecord::Migration
  def change
    create_table :paypal_users do |t|
      t.integer :user_id
      t.text :paypal_id
      t.string :access_token
      t.datetime :access_token_expires_at
      t.string :refresh_token
      t.boolean :declined, :default=>false

      t.timestamps
    end
  end
end
