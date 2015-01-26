require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:alan)
  end

  test "validation" do
    @user.create_validation
    email = UserMailer.validation(@user).deliver
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['support@betuabuck.com'], email.from
    assert_equal @user.email, email.to[0]
    assert_equal "Email Validation", email.subject
    body = email.body.to_s
    assert_match /footer/, body
    assert_match /https:\/\//, body
  end

  test "invitation" do
    addr = "foo@bar.com"
    @invitation = @user.invitations.create(:email=>addr)
    email = UserMailer.invitation(@invitation).deliver
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['support@betuabuck.com'], email.from
    assert_equal addr, email.to[0]
    assert_equal "Invitation to Join Bet U A Buck", email.subject
    body = email.body.to_s
    assert_match /footer/, body
    assert_match /https:\/\/.*\/signup/, body
  end
end
