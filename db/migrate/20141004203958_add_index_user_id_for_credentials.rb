class AddIndexUserIdForCredentials < ActiveRecord::Migration
  def change
    add_index :credentials, :user_id
  end
end
