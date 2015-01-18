require 'test_helper'

class HooksControllerTest < ActionController::TestCase
  test "should get venmo" do
    get :venmo
    assert_response :success
  end

end
