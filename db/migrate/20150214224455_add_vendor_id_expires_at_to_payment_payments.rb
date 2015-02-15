class AddVendorIdExpiresAtToPaymentPayments < ActiveRecord::Migration
  def change
    add_column :payment_payments, :vendor_id_expires_at, :datetime
  end
end
