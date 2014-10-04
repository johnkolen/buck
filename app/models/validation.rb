class Validation < ActiveRecord::Base
  belongs_to :user
  before_create :make_key

  def make_key
    Validation.where(:user_id=>user.id).delete_all
    salt = BCrypt::Engine.generate_salt
    self.key = BCrypt::Engine.hash_secret(user.email, salt)[10..33]
    self.expires_at = Time.now + 1.week
  end
end
