require 'transfer'
class ChangeDefaultStateInTransfers < ActiveRecord::Migration
  DEFAULT_STATE = 33 # Transfer.new.completed!.state
  def up
    Transfer.where(:state=>0).update_all(:state=>DEFAULT_STATE)
    change_column :transfers, :state, :integer, :default=>DEFAULT_STATE
  end
  def down
    Transfer.where(:state=>DEFAULT_STATE).update_all(:state=>0)
    change_column :transfers, :state, :integer, :default=>0
  end
end
