class Payment::Payment < ActiveRecord::Base
  self.inheritance_column = :vendor_class
  before_create :initialize_state

  belongs_to :transfer
  has_many(:logs,
           :class_name=>"Payment::Log",
           :foreign_key=>"payment_id",
           :dependent=>:delete_all)

  scope :pending_approval, -> { where(:state=>STATES[:approval]) }

  STATES = {
    :start=> 0,
    :sent=>100,
    :timed_out=>130,
    :received=>200,
    :approval=>300,
    :completed=>900,
    :failed=>999
  }
  @@state_str = {}
  STATES.each do |k,v|
    @@state_str[v] = k.to_s.humanize
    define_method(k) do |*args|
      self.state = v
      self
    end
    define_method("is_#{k}?") do
      self.state == STATES[k]
    end
  end
  def state_str
    @@state_str[state] || "None"
  end
  def state_str= v
    raise "bad state #{v}" unless STATES[v.to_sym]
    state = STATES[v.to_sym]
  end
  def initialize_state
    start unless self.state
  end
  def log message
    self.logs.create :message=>message
  end
  def initiate transfer
    raise "Payment#initiate undefined by subclass"
  end
  def vendor
    "NONE"
  end
  def self.create_by_vendor sym, params={}
    sym = :pay_pal if sym == :paypal
    eval("Payment::#{sym.to_s.classify}").create params
  end
  def vendor_timed_out
    self.transaction do
      self.reload
      if attempts >= 3
        self.failed
        self.retry_at = nil
      else
        self.retry_at = Time.now + 60 + rand(60)
        self.timed_out
      end
    end
    save
  end
end
