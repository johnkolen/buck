class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.integer :user_id
      t.string :key
      t.datetime :expires_at

      t.timestamps
    end
  end
end
