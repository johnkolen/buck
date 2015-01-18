class AddVendorIdToPaymentPayments < ActiveRecord::Migration
  def change
    add_column :payment_payments, :vendor_id, :string
  end
end
