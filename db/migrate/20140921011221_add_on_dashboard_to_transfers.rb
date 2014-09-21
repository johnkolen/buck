class AddOnDashboardToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :on_dashboard, :boolean, :default=>true
  end
end
