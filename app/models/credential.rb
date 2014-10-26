class Credential < ActiveRecord::Base
  attr_accessor :password

  validates :user, :presence=>true, :uniqueness=>true
  MIN_PASSWORD_LENGTH = Rails.env=="development" ? 3 : 8
  validates(:password,
            :if=>:has_password?,
            :confirmation=>{:message=>"Your password does not match the confirmation password."},
            :length=>{:minimum=>MIN_PASSWORD_LENGTH,
              :too_short=>"Try a longer password, at least "+
              "#{MIN_PASSWORD_LENGTH} characters."})

  belongs_to :user

  before_save :encrypt_password

  def has_password?
    #puts "password = #{password}"
    password.present?
    !password.nil?
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
