class Payment::Venmo < Payment::Payment
  def vendor
    "Venmo"
  end

  if Rails.env == "production"
    CLIENT_ID = 2219
    CLIENT_SECRET = "3nN6usT77kyxjVXQH8RTYVqkWrzkDGR5"
  else
    CLIENT_ID = 2221
    CLIENT_SECRET = "tJ3E29PLbYGbRQGCCpJtDwBtXjYBzz76"
  end

  @@use_sandbox = false
  def self.sandbox= value
    @@use_sandbox = (value == true)
  end

  HOST = "api.venmo.com"
  def self.url path
    host = HOST
    host = "sandbox-#{HOST}" if @@use_sandbox
    "https://#{host}/v1#{path}"
  end

  def self.resource path
    RestClient::Resource.new url(path)
  end

  def resource path
    self.class.resource path
  end

  def self.post_to_resource path, params
    resource(path).post params
  end

  def self.authorize_url user, destination=nil
    params = {
      :client_id=>CLIENT_ID,
      :scope=>"make_payments access_profile",
      :response_type=>"code",
      :state=>user.id.to_s
    }
    params[:state] = "#{params[:state]},#{destination}" if destination
    "#{url("/oauth/authorize")}?#{params.to_query}"
  end

  def self.update_access_token user, code
    params = {
      :client_id=>CLIENT_ID,
      :code=>code,
      :client_secret=>CLIENT_SECRET
    }
    response = post_to_resource("/oauth/access_token", params)
    return nil unless response.code == 200
    r = JSON.parse(response.to_s)
    return nil unless r["access_token"]
    venmo_user = user.venmo
    attributes = {
      :venmo_id=>r["user"]["id"],
      :access_token=>r["access_token"],
      :access_token_expires_at=>Time.now + r["expires_in"].to_i,
      :refresh_token=>r["refresh_token"],
      :declined=>false
    }
    if venmo_user
      venmo_user.update_attributes attributes
    else
      venmo_user = user.venmo_users.create attributes
    end
    venmo_user
  end

  def make_payment
    # from_user, to_user, note, amount
    note = "#{transfer.note || "betabuck transfer"}[#{transfer.id}]"
    # ensure that the access_token has not expired
    venmo_user = transfer.payment_source_user.venmo.refresh
    raise "Failed to refresh access_token" unless venmo_user
    params = {
      :access_token=>venmo_user.access_token,
      :note=>transfer.note || "betabuck transfer",
      :amount=>transfer.amount
    }
    recipient = transfer.payment_recipient_user
    if recipient.venmo.venmo_id
      params[:user_id] = recipient.venmo.venmo_id
    else
      params[:user_id] = recipient.email
    end
    self.class.send_request :post, "/payments", params
  end

  def self.send_request mode, path, params={}
    response = nil
    begin
      response = resource(path).send(mode, params)
    rescue RestClient::Exception => e
      return [e.http_code, JSON.parse(e.http_body)]
    end
    [response.code, JSON.parse(response.to_s)]
  end

  # initiate overrides Payment::Payment#initiate
  def initiate
    self.transaction do
      self.reload
      self.attempts += 1
      self.sent.save
    end
    code, response = make_payment
    if code == 200
      process_response response
      return  # don't log successful payments
    elsif code == 408 # request timeout
      vendor_timed_out
    else
      self.failed.save
    end

    msg = "request failed (#{code}) #{response.inspect}"
    self.log "venmo make_payment #{msg}"
    logger.warn "make_payment[#{self.inspect},#{self.transfer.inspect}]" +
      " #{msg}"
  end

  def process_response response
    self.transaction do
      self.reload
      status = response["data"]["payment"]["status"]
      self.vendor_id = response["data"]["payment"]["id"]
      case status
      when "settled"
        self.completed.save
      when "pending"
        self.received.save
      when "failed", "expired", "cancelled"
        self.log "venmo #{status} transfer: #{response.inspect}"
        logger.warn "venmo #{status} [#{self.inspect},#{self.transfer.inspect}] #{response.inspect}"
        self.failed.save
      end
    end
  end

  def self.get_payments user
    params = {
      :access_token=>user.venmo.access_token,
      # :limit=>10, #optional
    }
    send_request :get, "/payments?#{params.to_query}"
  end

  def self.me venmo_user
    params = {
      :access_token=>venmo_user.access_token,
    }
    send_request :get, "/me?#{params.to_query}"
  end
end
