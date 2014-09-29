class AddCommentAtToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :comment_at, :datetime
  end
end
