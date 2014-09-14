require 'test_helper'

class CredentialTest < ActiveSupport::TestCase
  def setup
    @user = users(:alan)
  end

  test "no user" do
    c = Credential.create
    assert c.new_record?
  end

  test "create by password without confirmation" do
    c = Credential.create :password=>"my_password"
    assert c.new_record?
  end

  test "create by password with confirmation" do
    p = "my_password"
    c = Credential.create(:user_id=>@user.id,
                          :password=>p,
                          :password_confirmation=>p)
    assert c.persisted?
  end

  test "create by password with bad confirmation" do
    p = "my_password"
    c = Credential.create(:user_id=>@user.id,
                          :password=>p,
                          :password_confirmation=>p+"!")
    assert c.new_record?
  end

end
