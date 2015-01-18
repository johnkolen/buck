require 'test_helper'

Payment::Venmo.sandbox = true

class PaymentVenmoSandboxTest < ActiveSupport::TestCase
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

  test "get payments" do
    v = Payment::Venmo.new
    Payment::Venmo.get_payments users(:alan)
  end

  test "make_payment success" do
    transfer = Transfer.create(transfer_params(10))
    v = Payment::Venmo.create(:transfer_id=>transfer.id)
    code, payload = v.make_payment
    assert_equal 200, code
    payment = payload["data"]["payment"]
    assert_equal "settled", payment["status"]
    assert_equal 0.10, payment["amount"]
  end

  test "make_payment fail" do
    transfer = Transfer.create(transfer_params(20))
    v = Payment::Venmo.create(:transfer_id=>transfer.id)
    code, payload = v.make_payment
    payment = payload["data"]["payment"]
    assert_equal 200, code
    assert_equal "failed", payment["status"]
    assert_equal 0.20, payload["data"]["payment"]["amount"]
  end

  [[:settled, :is_completed?],
   [:pending, :is_received?],
   [:failed, :is_failed?],
   [:expired, :is_failed?],
   [:cancelled, :is_failed?]].each do |label, query|
    test "process_response #{label}" do
      transfer = Transfer.create(transfer_params(10))
      v = Payment::Venmo.create(:transfer_id=>transfer.id)
      r = {"data"=>{"payment"=>{"status"=>label.to_s}}}
      v.sent.save
      v.process_response r
      assert v.send(query)
      if query == :is_failed?
        assert 1, v.logs.count
      else
        assert 0, v.logs.count
      end
    end
  end

  def transfer_params amount_cents
    {:user_id=>users(:alan).id,
      :recipient_id=>users(:venmo_sandbox).id,
      :amount_cents=>amount_cents,
      :note=>"a note",
      :kind=>0
      }
  end
end
