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

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name }
    end

    assert_redirected_to user_path(assigns(:user))
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

    assert_redirected_to user_path(assigns(:user))
    assert_equal 1, assigns(:user).credentials.count
    assert(!assigns(:user).credentials.first.encrypted_password.blank?,
           "missing encrypted password")
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
