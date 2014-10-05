class AddIndexesToTransfers < ActiveRecord::Migration
  def change
    add_index :transfers, :user_id
    add_index :transfers, :recipient_id
    add_index :transfers, :comment_at
  end
end
