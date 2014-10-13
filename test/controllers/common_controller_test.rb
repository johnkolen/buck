require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  test "should get hot" do
    get :hot
    assert_response :success
  end

  test "should get featured" do
    get :featured
    assert_response :success
  end

  test "should get sponsored" do
    get :sponsored
    assert_response :success
  end

  test "should get donate" do
    get :donate
    assert_response :success
  end

end
