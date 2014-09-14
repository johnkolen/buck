class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.integer :amount_cents
      t.text :note

      t.timestamps
    end
  end
end
