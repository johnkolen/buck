require 'test_helper'

class Admin::EmailAddressesControllerTest < ActionController::TestCase
  setup do
    @admin_email_address = admin_email_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_email_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_email_address" do
    assert_difference('Admin::EmailAddress.count') do
      post :create, admin_email_address: { email: @admin_email_address.email }
    end

    assert_redirected_to admin_email_address_path(assigns(:admin_email_address))
  end

  test "should show admin_email_address" do
    get :show, id: @admin_email_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_email_address
    assert_response :success
  end

  test "should update admin_email_address" do
    patch :update, id: @admin_email_address, admin_email_address: { email: @admin_email_address.email }
    assert_redirected_to admin_email_address_path(assigns(:admin_email_address))
  end

  test "should destroy admin_email_address" do
    assert_difference('Admin::EmailAddress.count', -1) do
      delete :destroy, id: @admin_email_address
    end

    assert_redirected_to admin_email_addresses_path
  end
end
