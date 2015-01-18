class RenameVendorInPayment < ActiveRecord::Migration
  def change
    rename_column :payment_payments, :vendor, :vendor_class
  end
end
