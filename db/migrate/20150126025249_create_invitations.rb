class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :email
      t.integer :msg_count, :default=>0
      t.string :key
      t.integer :signup_id

      t.timestamps
    end
  end
end
