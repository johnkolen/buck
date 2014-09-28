class AddAttachmentImageToTransfers < ActiveRecord::Migration
  def self.up
    change_table :transfers do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :transfers, :image
  end
end
