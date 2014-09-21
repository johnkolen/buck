class Comment < ActiveRecord::Base
  validates :transfer, :presence=>true
  validates :user, :presence=>true

  belongs_to :transfer
  belongs_to :user
end
