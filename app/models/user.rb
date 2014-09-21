class User < ActiveRecord::Base

  validates :first_name, :presence=>true
  validates :last_name, :presence=>true
  validates :email, :presence=>true
  validates :credentials, :presence=>true
  # email uniqueness

  has_many :credentials, :inverse_of=>:user, :dependent=>:destroy
  has_many :transfers, :inverse_of=>:user, :dependent=>:destroy
  has_many(:received_transfers,
           :foreign_key=>:recipient_id,
           :class_name=>"Transfer",
           :inverse_of=>:recipient,
           :dependent=>:destroy)
  has_many :comments

  # Credentials
  accepts_nested_attributes_for :credentials

  def password_credential
    credentials.where.not(:encrypted_password=>nil).first
  end

  def credential_type_list
    credentials.map{|c| c.type_name}.join(", ").html_safe
  end

  def credentials_ok? *opts
    if opts && opts.last.is_a?(Hash)
      if opts.last[:password]
        password_credential.authenticate? opts.last[:password]
      end
    end
  end

  def signin session
    session[:user_id] = id
    session[:is_admin] = is_admin
  end

  # Avatar
  has_attached_file(:avatar,
                    :styles=>{:medium=>"200x200>", :thumb=>"80x80>"},
                    :path=>"/users/avatars/:id_:basename.:style.:extension",
                    :default_url=>":style/missing-avatar.png")
  validates_attachment_content_type :avatar, :content_type=>/\Aimage\/.*\Z/

  # Helpers
  def full_name
    "#{first_name} #{last_name}"
  end

  def membership_time_str
    td = Time.now - created_at
    ActionController::Base.helpers.distance_of_time_in_words td
  end

  def descriptor
    full_name
  end
end
