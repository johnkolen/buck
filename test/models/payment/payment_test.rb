require 'test_helper'

class Payment::PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  [:start,:sent,:timed_out,:received,:completed,:failed].each do |action|
    test "state transition #{action}" do
      p = Payment::Payment.new
      p.send(action)
      assert p.send("is_#{action}?")
      assert_equal action.to_s.humanize, p.state_str
    end
  end
  test "initial state" do
    p = Payment::Payment.new
    assert p.send("is_start?")
  end
  test "create_by_vendor" do
    p = Payment::Payment.create_by_vendor :dummy
    assert "Dummy", p.vendor
  end
end
