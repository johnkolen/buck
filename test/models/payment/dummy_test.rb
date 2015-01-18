require 'test_helper'

class PaymentDummyTest < ActiveSupport::TestCase
  test "successful create" do
    d = Payment::Dummy.new
    d.save
    assert d.is_start?
    assert_equal "Payment::Dummy", d.vendor_class
  end
  test "initiate" do
    d = Payment::Dummy.create
    d.initiate
    assert d.is_completed?
    assert_equal 1, d.attempts
  end
  test "process_response" do
    d = Payment::Dummy.create
    d.initiate
    d.sent.save
    d.process_response {}
    assert d.is_completed?
    assert_equal 1, d.attempts
  end
  test "receive_from_vendor with error" do
    d = Payment::Dummy.create
    d.initiate
    d.sent.save
    d.process_response({"error"=>"error message"})
    assert d.is_failed?
    assert_equal 1, d.attempts
  end
  test "vendor_timed_out" do
    d = Payment::Dummy.create
    2.times do |i|
      d.initiate
      d.sent.save
      d.vendor_timed_out
      assert d.is_timed_out?, "failed on attempt #{i+1}"
      assert d.retry_at
      assert Time.now + 59 < d.retry_at, "retry_at set wrong"
    end
    d.initiate
    d.vendor_timed_out
    assert d.is_failed?
  end
end
