class AddIndexesToValidations < ActiveRecord::Migration
  def change
    add_index :validations, :user_id
    add_index :validations, :key
  end
end
