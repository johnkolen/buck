class User < ActiveRecord::Base

  validates :first_name, :presence=>true
  validates :last_name, :presence=>true
  validates :email, :presence=>true, :uniqueness=>true
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
  has_one :validation
  has_many :user_friends
  has_many :friends, :through=>:user_friends
  has_many :messages

  after_create :create_validation

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
    session[:pending] = self.validation(true) ? true : false
  end

  # Avatar
  has_attached_file(:avatar,
                    :styles=>{:medium=>"200x200>", :thumb=>"80x80>"},
                    :path=>"/users/avatars/:id_:basename.:style.:extension",
                    :default_url=>":style/missing-avatar.png")
  validates_attachment_content_type :avatar, :content_type=>/\Aimage\/.*\Z/

  # temporary password
  def create_temporary_password
    password = BCrypt::Engine.generate_salt[10..25]
    credentials.each do |credential|
      if credential.type_name == 'password'
        credential.delete
        credentials.create(:password=>password,
                           :temporary=>true,
                           :expires_at=>Time.now + 2.days)
        return password
      end
    end
    # you will need to login some otherway
    []  # alternate credentials
  end

  # Helpers
  def full_name
    "#{first_name} #{last_name}"
  end

  def current_password
  end

  def membership_time_str
    td = Time.now - created_at
    ActionController::Base.helpers.distance_of_time_in_words td
  end

  def descriptor
    full_name
  end

  def activity
    s = Transfer.new.user_completed!.recipient_completed!.state
    r = g = 0
    r += Transfer.where(:state=>s,
                        :recipient_id=>self.id,
                        :kind=>Transfer::NORMAL_KINDS).sum(:amount_cents)
    r += Transfer.where(:state=>s,
                        :user_id=>self.id,
                        :kind=>Transfer::REVERSE_KINDS).sum(:amount_cents)
    g += Transfer.where(:state=>s,
                        :user_id=>self.id,
                        :kind=>Transfer::NORMAL_KINDS).sum(:amount_cents)
    g += Transfer.where(:state=>s,
                        :recipient_id=>self.id,
                        :kind=>Transfer::REVERSE_KINDS).sum(:amount_cents)
    {:receive=>r/100.0,:give=>g/100.0}
  end

  def is_friend? other
    self.user_friends.where(:friend_id=>other.id).exists?
  end
end
