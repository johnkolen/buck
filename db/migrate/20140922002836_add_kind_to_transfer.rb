class AddKindToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :kind, :integer, :default=>0
  end
end
