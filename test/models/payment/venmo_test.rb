require 'test_helper'

Payment::Venmo.sandbox = true

class PaymentVenmoTest < ActiveSupport::TestCase
  test "successful create" do
    v = Payment::Venmo.new
  end

  test "authorize_url" do
    user = users(:alan)
    url = Payment::Venmo.authorize_url user
    assert /v1\/oauth\/authorize/ =~ url
    assert /client_id=#{Payment::Venmo::CLIENT_ID}/ =~ url
    assert /state=#{user.id}/ =~ url
  end

  test "initiate returns settled" do
    transfer = Transfer.create(transfer_params(100))
    v = Payment::Venmo.create(:transfer_id=>transfer.id)
    v.expects(:make_payment).returns([200, venmo_response("settled")])
    v.initiate
    assert v.is_completed?
    assert_equal 1, v.attempts
  end

  test "initiate returns failed" do
    transfer = Transfer.create(transfer_params(100))
    v = Payment::Venmo.create(:transfer_id=>transfer.id)
    v.expects(:make_payment).returns([200, venmo_response("failed")])
    v.initiate
    assert v.is_failed?
    assert_equal 1, v.attempts
  end

  test "initiate times out" do
    transfer = Transfer.create(transfer_params(100))
    v = Payment::Venmo.create(:transfer_id=>transfer.id)
    v.expects(:make_payment).returns([408, "timed out"])
    v.initiate
    assert v.is_timed_out?
    assert_equal 1, v.attempts
  end

  def transfer_params amount_cents
    {:user_id=>users(:alan).id,
      :recipient_id=>users(:venmo_sandbox).id,
      :amount_cents=>amount_cents,
      :note=>"a note",
      :kind=>0
      }
  end

  def venmo_response status
    {"data"=>{
        "payment"=>{
          "status"=>status
        }
      }
    }
  end
end
