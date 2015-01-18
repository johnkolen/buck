class AddStateDefaultValuePayments < ActiveRecord::Migration
  def change
    change_column :payment_payments, :state, :integer, :default=>0
  end
end
