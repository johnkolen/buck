class AddAttemptsToPaymentPayments < ActiveRecord::Migration
  def change
    add_column :payment_payments, :attempts, :integer, :default=>0
  end
end
