require 'test_helper'

class Payment::LogTest < ActiveSupport::TestCase
  test "attach to payment" do
    p = Payment::Payment.create
    msg = "log message 1"
    assert_difference "p.logs.count" do
      p.logs.create :message=>msg
    end
    log = p.logs.first
    assert msg, log.message
    assert p.id, log.payment.id
    assert_difference "p.logs.count" do
      p.logs.create :message=>"message 2"
    end
  end
end
