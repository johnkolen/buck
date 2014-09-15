require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session" do
    alan = users(:alan)
    post :create, :email=>alan.email, :password=>'alan123'
    assert_redirected_to dashboard_user_path(alan)
    assert_equal alan.id, session[:user_id]
  end

  test "should delete destroy" do
    delete :destroy
    assert_redirected_to root_path
    assert !session[:user_id]
  end

end
