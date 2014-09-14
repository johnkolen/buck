class User < ActiveRecord::Base

  validates :first_name, :presence=>true
  validates :last_name, :presence=>true
  validates :email, :presence=>true
  # email uniqueness

  has_many :credentials, :inverse_of=>:user

  accepts_nested_attributes_for :credentials

  def password_credential
    credentials.where.not(:encrypted_password=>nil).first
  end

  def credential_type_list
    credentials.map{|c| c.type_name}.join(", ").html_safe
  end
end
