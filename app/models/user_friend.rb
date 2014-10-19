class UserFriend < ActiveRecord::Base
  validate :user_id, :presence=>true
  validate :friend_id, :presence=>true
  validate :user, :presence=>true
  validate :friend, :presence=>true

  belongs_to :user
  belongs_to :friend, :class_name=>"User"
end
