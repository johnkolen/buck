require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "create empty user" do
    user = User.create
    assert user.new_record?
  end
  [:first_name, :last_name, :email].each do |tgt|
    test "create missing #{tgt}" do
      h = new_user_params
      h.delete tgt
      user = User.create h
      assert user.new_record?
    end
  end

  test "create" do
    user = User.create new_user_params
    assert user.persisted?
  end

  test "create with password credentials" do
    h = new_user_params
    p = "my_password"
    h[:credentials_attributes] =
      {"0"=>{:password=>p, :password_confirmation=>p}}
    user = User.create! h
    assert user.persisted?, "user not saved"
    assert user.credentials.first.persisted?, "credential not saved"
  end

  def new_user_params
    {:first_name=>"Alan", :last_name=>"Archer", :email=>"alan@mail.com"}
  end
end
