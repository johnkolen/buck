class AddRetryAtToPaymentPayments < ActiveRecord::Migration
  def change
    add_column :payment_payments, :retry_at, :datetime
  end
end
