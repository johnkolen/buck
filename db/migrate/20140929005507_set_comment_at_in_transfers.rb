class SetCommentAtInTransfers < ActiveRecord::Migration
  def up
    #Transfer.where(:comment_at=>nil).each do |t|
    Transfer.all.each do |t|
      t.update_attribute(:comment_at,
                         t.comments.maximum(:updated_at) || t.created_at)
    end
  end
  def down
    # nothing
  end
end
