class AddFlipToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :flip, :boolean, :default=>false
  end
end
