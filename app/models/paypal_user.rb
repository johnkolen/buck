class PaypalUser < ActiveRecord::Base
  belongs_to :user

  def refresh
    return self if !refresh_token || Time.now < access_token_expires_at
    tokeninfo = PayPal::SDK::OpenIDConnect::Tokeninfo.refresh refresh_token
    return nil unless tokeninfo.access_token
    attributes = {
      :access_token=>tokeninfo.access_token,
      :access_token_expires_at=>Time.now + tokeninfo.expires_in.to_i,
      :refresh_token=>tokeninfo.refresh_token
    }
    update_attributes attributes
    self
  end

  # a user can receive money if they have authorized with paypal
  def can_receive_money?
    access_token && !declined && true
  end

  def active?
    (!refresh_token || Time.now < access_token_expires_at) && true
  end
end
