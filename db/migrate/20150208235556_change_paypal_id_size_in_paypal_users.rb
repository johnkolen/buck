class ChangePaypalIdSizeInPaypalUsers < ActiveRecord::Migration
  def change
    change_column :paypal_users, :paypal_id, :text, :limit=>1024
  end
end
