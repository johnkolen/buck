require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get root" do
    get :root
    assert_response :success
  end

  test "should get toc" do
    get :toc
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
