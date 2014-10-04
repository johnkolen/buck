require 'test_helper'

class ValidationTest < ActiveSupport::TestCase
  test "make_key" do
    v = Validation.new :user_id=>users(:alan).id
    assert_not v.key
    assert_not v.expires_at
    v.make_key
    assert v.key
    assert v.expires_at
  end
  test "make_key create" do
    v = Validation.create :user_id=>users(:alan).id
    assert v.key
    assert v.expires_at
  end
end
