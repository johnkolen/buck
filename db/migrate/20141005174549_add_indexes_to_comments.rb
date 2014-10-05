class AddIndexesToComments < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :comments, :transfer_id
  end
end
