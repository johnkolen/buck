class UserMailer < ActionMailer::Base
  default from: "support@betuabuck.com"

  def validation user
    @user = user
    change_default_host validate_users_url(@user) do
      mail :to=>@user.email, :subject=>"Email Validation"
    end
  end

  def temp_password user, password
    @user = user
    @password = password
    change_default_host validate_users_url(@user) do
      mail :to=>@user.email, :subject=>"Temporary Password"
    end
  end

  protected
  def change_default_host url
    return yield unless url
    uri = URI(url)
    @host = uri.host
    @port = uri.port
    old_host = self.default_url_options[:host]
    old_port = self.default_url_options[:port]
    self.default_url_options[:host]=@host
    self.default_url_options[:port]=@port
    result = yield
    self.default_url_options[:host]=old_host
    self.default_url_options.delete(:port)
    self.default_url_options[:port] = old_port if old_port
    result
  end

end
