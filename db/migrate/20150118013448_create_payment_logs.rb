class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs do |t|
      t.integer :payment_id
      t.text :message

      t.timestamps
    end
  end
end
