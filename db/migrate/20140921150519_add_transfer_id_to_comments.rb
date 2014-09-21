class AddTransferIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :transfer_id, :integer
  end
end
