class AddStateToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :state, :integer, :default=>0
  end
end
