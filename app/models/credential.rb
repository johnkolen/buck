class Credential < ActiveRecord::Base
  attr_accessor :password

  validates :user, :presence=>true, :uniqueness=>true
  validates :password, :confirmation=>true, :if=>:has_password?

  belongs_to :user

  before_save :encrypt_password

  def has_password?
    #puts "password = #{password}"
    password.present?
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password =
        BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def authenticate? pwd
    encrypted_password == BCrypt::Engine.hash_secret(pwd, salt)
  end

  def type_name
    if encrypted_password
      "password"
    else
      "none"
    end
  end
end
