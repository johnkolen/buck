class TransferValidator < ActiveModel::Validator
  def validate transfer
    if transfer.user_id == transfer.recipient_id
      transfer.errors[:recipient_id] << "Recipient can't be self."
    end
  end
end

class Transfer < ActiveRecord::Base
  validates :amount_cents, :presence=>true
  validates :user, :presence=>true
  validates :recipient, :presence=>true
  validates :note, :presence=>true
  validates(:amount_cents,
            :numericality=>{:greater_than=>0,
              :less_than_or_equal_to=>500})
  validates_with TransferValidator

  belongs_to :user, :inverse_of=>:transfers
  belongs_to :recipient, :class_name=>"User", :inverse_of=>:received_transfers
  has_many :comments
  has_one :payment, :class_name=>"Payment::Payment"

  before_create :initialize_state
  before_create :initialize_comment_at

  scope(:involving,
        ->(user){ where("user_id = ? OR recipient_id = ?", user.id, user.id) })

  scope(:both_completed, -> { where(:state=>BOTH_COMPLETED) })

  def created_at_tz
    if created_at
      created_at.in_time_zone(user.time_zone)
    else
      nil
    end
  end

  def amount
    amount_cents / 100.0 if amount_cents
  end

  def amount= value
    if value
      self.amount_cents = (value.to_f * 100.0).to_i
    else
      self.amount_cents = nil
    end
  end

  def other_user u
    if user_id == u.id
      self.recipient
    else
      self.user
    end
  end

  def payment_source_user
    if is_pay? || is_failed_bet? || is_pledge?
      user
    else
      recipient
    end
  end

  def payment_recipient_user
    if is_pay? || is_failed_bet? || is_pledge?
      recipient
    else
      user
    end
  end

  def payment_source_user_id
    if is_pay? || is_failed_bet? || is_pledge?
      user_id
    else
      recipient_id
    end
  end

  def payment_recipient_user_id
    if is_pay? || is_failed_bet? || is_pledge?
      recipient_id
    else
      user_id
    end
  end

  def payment_state
    if payment
      "#{payment.vendor}:#{payment.state_str}"
    else
      "no payment"
    end
  end

  def payment_log
    if payment
      payment.logs.map {|log| [log.created_at, log.message]}
    else
      []
    end
  end

  KIND_PAY = 0
  KIND_REQUEST = 1
  KIND_BET = 2
  KIND_PLEDGE = 3
  KIND_OPTIONS = [["I will pay to", KIND_PAY],
                   ["I request from", KIND_REQUEST],
                   ["I bet", KIND_BET],
                   ["I pledge to", KIND_PLEDGE]]
  KINDS = KIND_OPTIONS.to_h.merge(KIND_OPTIONS.map{|x|x.reverse}.to_h)
  KIND_STR = {KIND_PAY=>"Pay",
    KIND_REQUEST=>"Request",
    KIND_BET=>"Bet",
    KIND_PLEDGE=>"Pledge"}
  NORMAL_KINDS = [KIND_PAY, KIND_BET, KIND_PLEDGE]
  REVERSE_KINDS = [KIND_PLEDGE]

  def self.kind_options
    KIND_OPTIONS
  end

  def kind_str
    KIND_STR[self.kind]
  end

  USER_MASK = 31
  RECIPIENT_SHIFT = 5
  RECIPIENT_MASK = 31 << RECIPIENT_SHIFT
  STATE_BASE = {:completed=>1,
    :failed=>2,:canceled=>4,:pending=>8,:pending_accept=>16}
  @@state_str = {}
  STATE_BASE.each do |k,v|
    @@state_str[v] = "User #{k.to_s.sub('_',' ').capitalize}"
    @@state_str[v << RECIPIENT_SHIFT] =
      "Recipient #{k.to_s.sub('_',' ').capitalize}"
    const_set("user_#{k}".upcase, v)
    define_method("user_#{k}!") do
      self.state = (self.state & ~USER_MASK) | v
      self
    end
    const_set("recipient_#{k}".upcase,
              v << RECIPIENT_SHIFT)
    define_method("recipient_#{k}!") do
      self.state = (self.state & ~RECIPIENT_MASK) | (v << RECIPIENT_SHIFT)
      self
    end
    const_set("both_#{k}".upcase,
              v | (v << RECIPIENT_SHIFT))
    define_method("user_#{k}?") do
      (self.state & USER_MASK) == v
    end
    define_method("recipient_#{k}?") do
      (self.state & RECIPIENT_MASK) == v << RECIPIENT_SHIFT
    end
    define_method("either_#{k}?") do
      send("user_#{k}?") || send("recipient_#{k}?")
    end
    define_method("both_#{k}?") do
      send("user_#{k}?") && send("recipient_#{k}?")
    end
  end

  def self.base_state_options u
    STATE_BASE.
      to_a.
      sort_by{|a| a.last}.
      map{|k,v| ["#{u} #{k.to_s.sub('_',' ').capitalize}", v]}
  end

  def self.user_state_options
    base_state_options "User"
  end

  def self.recipient_state_options
    base_state_options "Recipient"
  end

  def state_str
    "#{@@state_str[state & USER_MASK]}.#{@@state_str[state & RECIPIENT_MASK]}"
  end

  def pending!
    user_pending!
    recipient_pending!
  end

  def completed!
    user_completed!
    recipient_completed!
  end

  def pending?
    !finalized?
  end

  def finalized?
    completed? || failed? || canceled?
  end

  def failed?
    both_failed?
  end

  def canceled?
    both_canceled?
  end

  def completed?
    both_completed?
  end

  def completed!
    user_completed!
    recipient_completed!
  end

  def initialize_state
    case self.kind
    when KIND_PAY, KIND_REQUEST
      self.user_completed!
      self.recipient_pending!
    when KIND_BET, KIND_PLEDGE
      self.user_pending!
      self.recipient_pending_accept!
    end
  end

  def is_pay?
    kind == KIND_PAY
  end

  def is_request?
    kind == KIND_REQUEST
  end

  def is_bet?
    kind == KIND_BET
  end

  def is_pledge?
    kind == KIND_PLEDGE
  end

  def is_unconditional?
    is_pay? || is_request?
  end

  def is_conditional?
    is_bet? || is_pledge?
  end

  def is_pending_request?
    kind == KIND_REQUEST && pending?
  end

  def is_pending_bet?
    kind == KIND_BET && pending?
  end

  def is_pending_pledge?
    kind == KIND_PLEDGE && pending?
  end

  def is_failed_bet?
    kind == KIND_BET && both_failed?
  end

  def is_completed_bet?
    kind == KIND_BET && both_completed?
  end

  def user_state
    self.state & USER_MASK
  end

  def user_state= x
    self.state = (self.state & ~USER_MASK) | x.to_i
  end

  def recipient_state
    self.state & RECIPIENT_MASK
  end

  def recipient_state= x
    self.state = (self.state & ~RECIPIENT_MASK) | (x.to_i << RECIPIENT_SHIFT)
  end

  def update_complete uid
    return if finalized?
    if self.recipient_id == uid
      recipient_completed!.save
    elsif self.user_id == uid
      user_completed!.save
    end
    # only move money on transition
    initiate_payment if completed?
  end

  def update_accept uid
    return if finalized?
    if self.recipient_id == uid
      if self.is_unconditional?
        completed!
        save
        initiate_payment
      else
        recipient_pending!.save
      end
      # else  user has accepted by initiating the transfer
    end
  end

  def update_cancel uid
    return if finalized?
    if self.recipient_id == uid
      self.recipient_canceled!
      user_canceled! if is_unconditional?
      save
    elsif self.user_id == uid
      user_canceled!
      recipient_canceled! if is_unconditional?
      save
    end
  end

  def update_fail uid
    return if finalized?
    if self.is_bet? || self.is_pledge?
      if self.recipient_id == uid
        recipient_failed!.save
      elsif self.user_id == uid
        user_failed!.save
      end
    end
    initiate_payment if self.failed?
  end

  # Image
  has_attached_file(:image,
                    :styles=>{:medium=>"200x200>", :thumb=>"80x80>"},
                    :path=>"/transfers/images/:id_:basename.:style.:extension",
                    :default_url=>":style/missing-image.png")
  validates_attachment_content_type :image, :content_type=>/\Aimage\/.*\Z/

  def initialize_comment_at
    self.comment_at = Time.now
  end

  def self.recent number=10
    xfers = order(:comment_at=>:desc).limit(number)
  end

  def message
    case self.kind
    when KIND_PAY
      sprintf "Payment of $%.2f to %s %s.", self.amount, recipient.first_name, self.note
    when KIND_REQUEST
      sprintf "I request $%.2f from %s %s.", self.amount, recipient.first_name, self.note
    when KIND_BET
      sprintf("I bet %s, $%.2f, %s. If you fail, you will pay me $%.2f.",
              recipient.first_name, self.amount, self.note, self.amount)
    when KIND_PLEDGE
      sprintf "I pledge to pay %s, $%.2f, %s.", recipient.first_name, self.amount, self.note
    end
  end

  before_save :update_comment_at
  def update_comment_at
    self.comment_at = Time.now
  end

  def initiate_payment
    return unless completed?
    vendor = Rails.application.config.payment_vendor
    self.payment = Payment::Payment.create_by_vendor vendor
    self.payment.initiate
  end
end

