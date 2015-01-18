require 'test_helper'

class MockResource
  def initialize path
    @path = path
  end
  def post
  end
end
class MockResponse
  attr_accessor :code
  def initialize code, contents
    @code = code
    @contents = contents
  end
  def to_s
    @contents
  end
end

class CallbackControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "venmo oauth accepted" do
    user = users(:alan)
    destination = "/users/#{user.id}/dashboard"
    state="#{user.id},#{destination}"
    code = "123456"
    access_token = "987654"
    venmo_user_id = "3273278"
    response = {:access_token=>access_token,:expires_in=>6000, :type=>"bearer"}
    response[:user]={:id=>venmo_user_id}

    Payment::Venmo.expects(:post_to_resource).
      with(){|path, hash| path == "/oauth/access_token"}.
      returns(MockResponse.new 200, JSON.generate(response))

    get :venmo, {:state=>state, :code=>code}
    assert_redirected_to destination
    assert_equal access_token, user.venmo.access_token
    assert_equal venmo_user_id, user.venmo.venmo_id
    assert !user.venmo.declined?
  end

  test "venmo oauth declined" do
    user = users(:alan)
    destination = "/users/#{user.id}/dashboard"
    state="#{user.id},#{destination}"
    declined="User denied your application access to " +
      "his or her protected resources."
    get :venmo, {:state=>state, :error=>declined}
    assert user.venmo.declined?, "should be declined"
    assert_nil user.venmo.access_token
    assert_redirected_to destination
  end
end
