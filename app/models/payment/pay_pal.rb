# stupid hack because 1.1.1 doesn't autoload VERSION in paypal core
PayPal::SDK::OpenIDConnect::API::VERSION = PayPal::SDK::REST::VERSION
PayPal::SDK::Core::API::VERSION = PayPal::SDK::AdaptivePayments::VERSION

class Payment::PayPal < Payment::Payment
  # include PayPal::SDK::REST

  def vendor
    "PayPal"
  end

  if Rails.env == "production"
  else
  end

  @@use_sandbox = false
  def self.sandbox= value
    @@use_sandbox = (value == true)
  end

  HOST = "paypal.com"
  def self.url path
    host = HOST
    host = "sandbox.#{HOST}" if @@use_sandbox
    "https://#{host}/#{path}"
  end

  def self.redirect_url
    "https://betuabuck.ngrok.com/callback/paypal"
  end

  def self.resource path
    RestClient::Resource.new url(path)
  end

  def resource path
    self.class.resource path
  end

  def self.nonce
    Base64::encode64 rand.to_s
  end

  def self.authorize_url user, destination=nil
    state = user ? user.id : "none"
    state = "#{state},#{destination}" if destination
    PayPal::SDK::OpenIDConnect::Tokeninfo.
      authorize_url(:scope=>"openid profile email",
                    :state=>state,
                    :nonce=>self.nonce,
                    :redirect_uri=> redirect_url + "_auth")
  end

  def self.create_tokeninfo code
    PayPal::SDK::OpenIDConnect::Tokeninfo.create(code)
  end

  def self.update_access_token user, code
    tokeninfo = create_tokeninfo code
    paypal_user = user.paypal
    attributes = {
      :paypal_id=>tokeninfo.id_token,
      :access_token=>tokeninfo.access_token,
      :access_token_expires_at=>Time.now + tokeninfo.expires_in,
      :refresh_token=>tokeninfo.refresh_token,
      :declined=>false
    }
    if paypal_user
      paypal_user.update_attributes attributes
    else
      paypal_user = user.paypal_users.create! attributes
    end
  end

  def refresh_vendor_id
    if !vendor_id_expires_at || vendor_id_expires_at < Time.now
      process_response make_payment
    end
  end

  def make_payment
    params = payment_params
    add_receiver params
    self.class.send_payment_request params
  end

  def self.send_payment_request params
    api = PayPal::SDK::AdaptivePayments.new
    pay = api.build_pay params
    response = api.pay(pay)
    puts response.inspect
    if response.success? && response.payment_exec_status != "ERROR"
      response
    else
      raise response.error.map {|x| x.message }.join("\n")
    end
  end

  def payment_params
    source_user = transfer.payment_source_user.paypal.refresh
    #source_ui = PayPal::SDK::OpenIDConnect::Userinfo.get(source_user.access_token)
    #puts source_ui.user_id
    #puts source_user.paypal_id
    params = {
      :actionType=>"PAY",
      :clientDetails=>{
        :applicationId=>"Bet U A Buck",
        :customerId=>"#{source_user.id}"
      },
      #:sender=>{:accountId=>source_user.paypal_id},
      :senderEmail=>transfer.payment_source_user.email,
      :cancelUrl=>self.class.redirect_url + "_cancel",
      :currency_code=>"USD",
      :feesPayer=>"SENDER",
      :ipnNotificationUrl=>self.class.redirect_url,
      :memo=>"Bet U A Buck Transfer",
      :receiverList=>{
        :receiver=>[]
      },
      :returnUrl=>self.class.redirect_url + "_return"
    }
  end

  def add_receiver params
    receive_user = transfer.payment_recipient_user.paypal.refresh
    note = "#{(transfer.note || "betuabuck transfer")[0..99]} [#{transfer.id}]"
    receiver = {
      :amount=>transfer.amount,
      :paymentType=>'PERSONAL',
      :email=>transfer.payment_recipient_user.email,
      #:accountId=>receive_user.paypal_id}]
      :invoiceId=>note
    }
    params[:receiverList][:receiver].push receiver
  end

  def self.me
  end

  # initiate overrides Payment::Payment#initiate
  def initiate
    self.transaction do
      self.reload
      self.attempts += 1
      self.sent.save
    end
    response = make_payment
    if response
      process_response response
      return  # don't log successful payments
    else
      self.failed.save
    end

    msg = "request failed (#{code}) #{response.inspect}"
    self.log "paypal make_payment #{msg}"
    logger.warn "make_payment[#{self.inspect},#{self.transfer.inspect}]" +
      " #{msg}"
  end

  def self.make_payments payments
    params = payments.first.payment_params
    payments.each do |p|
      p.add_receiver params
    end
    send_payment_request params
  end

  def self.initiate payments
    self.transaction do
      payments.each do |p|
        p.reload
        p.attempts += 1
        p.sent.save
      end
    end
    response = make_payments payments
    if response
      process_response response
      return  # don't log successful payments
    else
      self.failed.save
    end

    msg = "request failed (#{code}) #{response.inspect}"
    self.log "paypal make_payment #{msg}"
    logger.warn "make_payment[#{self.inspect},#{self.transfer.inspect}]" +
      " #{msg}"
  end

  def process_response response
    status = response.payment_exec_status
    raise "missing payKey" unless response.payKey
    self.transaction do
      self.reload
      self.vendor_id = response.payKey
      self.vendor_id_expires_at = Time.now + 3.hours - 10.minutes
      case status
      when "CREATED"
        self.approval.save
      when "COMPLETED"
        self.completed.save
      when "PROCESSING","PENDING"
        self.received.save
      when "ERROR"
        error_msg = response.error.map {|x| x.message }.join("\n")
        self.log "paypal #{status} " +
          "transfer: #{response.inspect} msg:#{error_msg}"
        logger.warn "paypal #{status} " +
          "[#{self.inspect},#{self.transfer.inspect}] #{response.inspect}"
        self.failed.save
      end
    end
  end

  def self.payments
    PayPal::SDK::REST::Payment.all(:count=>5)
  end

  class PayKeyWrapper
    attr_reader :payKey
    def initialize id
      @payKey = id
    end
  end

  def self.approval_urls payments
    return [] if payments.empty?
    id_count = Hash.new{|h,k| h[k] = 0}
    payments.each do |p|
      p.refresh_vendor_id
      if p.vendor_id
        id_count[p.vendor_id] += 1
      end
    end
    result = id_count.keys.sort{|a,b| id_count[a] <=> id_count[b]}
    api = PayPal::SDK::AdaptivePayments.new
    result.map do |id|
      api.payment_url(PayKeyWrapper.new(id))
    end
  end

  def self.process_ipn params
    if params["status"] == "COMPLETED"
      puts "COMPLETED"
      params["transaction"].values.each do |txn|
        puts txn.inspect
        puts txn[".invoiceId"].inspect
        if txn[".invoiceId"] && /\[(\d+)\]$/ =~ txn[".invoiceId"]
          puts "Has invoiceId #{$1}"
          transfer = Transfer.includes(:payment).find($1.to_i)
          payment = transfer.payment
          puts txn[".status_for_sender_txn"].inspect
          if txn[".status_for_sender_txn"] == "Completed"
            puts "is completed"
            payment.completed.save
          end
        end
      end
    end
  end
end

