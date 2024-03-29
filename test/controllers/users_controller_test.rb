require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:alan)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create user missing password" do
    assert_no_difference('User.count') do
      post :create, user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name }
    end

    # try entering it again
    assert_response :success
  end

  test "should create user with password" do
    p = "my_password"
    assert_difference('User.count') do
      h = {user: { email: @user.email,
          first_name: @user.first_name,
          last_name: @user.last_name,
        credentials_attributes: {"0"=>{password: p, password_confirmation: p}}}}
      post :create, h
    end

    assert_redirected_to dashboard_user_path(assigns(:user))
    assert_equal 1, assigns(:user).credentials.count
    assert(!assigns(:user).credentials.first.encrypted_password.blank?,
           "missing encrypted password")
  end

  test "should show user" do
    get :show, {id: @user}, {:user_id=>@user.id}
    assert_response :success
  end

  test "should show user from other user" do
    @other_user = users(:bob)
    get :show, {id: @user}, {:user_id=>@other_user}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @user}, {:user_id=>@user.id}
    assert_response :success
  end

  test "fail get edit other user" do
    @other_user = users(:bob)
    get :edit, {id: @user}, {:user_id=>@other_user}
    assert_redirected_to user_path(@other_user)
  end

  test "should update user" do
    assert_not_equal 'x',  @user.last_name[-1], "precondition"
    patch :update, {id: @user, user: { email: @user.email+'x', first_name: @user.first_name+'x', last_name: @user.last_name+'x' }}, {:user_id=>@user.id}
    assert_redirected_to user_path(assigns(:user))
    @user.reload
    assert_equal 'x',  @user.last_name[-1]
  end

  test "should not update other user" do
    @other_user = users(:bob)
    assert_not_equal 'x',  @user.last_name[-1], "precondition"
    patch :update, {id: @user, user: { email: @user.email+'x', first_name: @user.first_name+'x', last_name: @user.last_name+'x' }}, {:user_id=>@other_user}
    assert_redirected_to user_path(@other_user)
    @user.reload
    assert_not_equal 'x',  @user.last_name[-1]
  end

end
