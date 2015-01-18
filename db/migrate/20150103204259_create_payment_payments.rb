class CreatePaymentPayments < ActiveRecord::Migration
  def change
    create_table :payment_payments do |t|
      t.integer :transfer_id
      t.integer :state
      t.string :vendor

      t.timestamps
    end
  end
end
