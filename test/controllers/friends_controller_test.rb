require 'test_helper'

class FriendsControllerTest < ActionController::TestCase
  def setup
    @user = users(:alan)
    @friend = users(:alan)
    @session_hash = {:user_id=>@user.id}
  end

  test "add" do
    assert_difference "@user.friends.count()", 1 do
      xhr :post, :add, {:id=>@friend.id}, @session_hash
    end
    assert_response :success
  end
  test "add twice" do
    xhr :post, :add, {:id=>@friend.id}, @session_hash
    assert_difference "@user.friends.count()", 0 do
      xhr :post, :add, {:id=>@friend.id}, @session_hash
    end
    assert_response :success
  end


  test "remove" do
    @user.user_friends.create(:friend_id=>@friend.id)
    assert_difference "@user.friends.count()", -1 do
      xhr :post, :remove, {:id=>@friend.id}, @session_hash
      @user.reload
    end
    assert_response :success
  end
  test "remove twice" do
    @user.user_friends.create(:friend_id=>@friend.id)
    xhr :post, :remove, {:id=>@friend.id}, @session_hash
    assert_difference "@user.friends.count()", 0 do
      xhr :post, :remove, {:id=>@friend.id}, @session_hash
      @user.reload
    end
    assert_response :success
  end
end
