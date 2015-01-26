class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :signup, :class_name=>"User"

  before_create :make_key

  def make_key
    salt = BCrypt::Engine.generate_salt
    self.key = BCrypt::Engine.hash_secret(self.email + user.email, salt)[10..33]
  end

  def signup_at
    self.signup && self.signup.created_at
  end
end
