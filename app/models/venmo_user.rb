class VenmoUser < ActiveRecord::Base
  belongs_to :user

  def refresh
    return self if !refresh_token || Time.now < access_token_expires_at
    params = {
      :client_id=>Payment::Venmo.CLIENT_ID,
      :client_secret=>Payment::Venmo.CLIENT_SECRET,
      :refresh_token=>refresh_token,
    }
    response = nil
    begin
      response = resource("/oauth/access_token").post params
    rescue Exception => e
      puts e.inspect
    end
    r = JSON.parse(response.to_s)
    return nil unless r["access_token"]
    attributes = {
      :access_token=>r["access_token"],
      :access_token_expires_at=>Time.now + r["expires_in"].to_i,
      :refresh_token=>r["refresh_token"]
    }
    update_attributes attributes
    self
  end

  def active?
    (!refresh_token || Time.now < access_token_expires_at) && true
  end
end
