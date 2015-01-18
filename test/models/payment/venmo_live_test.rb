require 'test_helper'

Payment::Venmo.sandbox = false

class PaymentVenmoLiveTest < ActiveSupport::TestCase
  @@user_ids = {}
  @@user_tokens = {}
  def make_user num, get_id=true
    u = users("venmo_live_#{num}")
    if u.venmo.access_token == "TBA"
      @@user_tokens[num] ||= get_env("VENMO_ACCESS_TOKEN_#{num}")
      u.venmo.update_attribute(:access_token,
                               @@user_tokens[num])
    end
    if get_id && !u.venmo.venmo_id
      unless @@user_ids[num]
        code, response = Payment::Venmo.me u.venmo
        assert 200, code
        @@user_ids[num] = response["data"]["user"]["id"]
      end
      u.venmo.update_attribute(:venmo_id, @@user_ids[num])
    end
    u
  end

  def setup
  end

  test "me" do
    @live_1 = make_user 1, false
    code, response = Payment::Venmo.me @live_1.venmo
    assert_equal 200, code
    assert response["data"]
    assert response["data"]["user"]
    assert response["data"]["user"]["id"]
  end

  test "make payment" do
    live_1 = make_user 2
    live_2 = make_user 1
    num = Time.now.strftime("%Y%m%d%H%M%S")
    make_payment live_1, live_2, "make_payment test #{num}"
    make_payment live_2, live_1, "make_payment test #{num} reverse"
  end

  def make_payment user_1, user_2, note, amount=100
    transfer = Transfer.create transfer_params(user_1, user_2, amount, note)
    venmo = Payment::Venmo.create :transfer_id=>transfer.id
    code, response = venmo.make_payment
    assert_equal 200, code, "response = #{response.inspect}"
    assert response["data"]
    assert response["data"]["payment"]
    assert "settled", response["data"]["payment"]["status"]
  end

  def get_env x
    ENV[x] || raise("define environment variable: #{x}")
  end

  def transfer_params src, dest, amount_cents, note="betuabuck test"
    {:user_id=>src.id,
      :recipient_id=>dest.id,
      :amount_cents=>amount_cents,
      :note=>note,
      :kind=>0
      }
  end
end
