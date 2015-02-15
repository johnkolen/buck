require 'test_helper'

class PaymentPayPalLiveTest < ActiveSupport::TestCase
  test "make payment" do
    live_1 = make_user 2
    live_2 = make_user 1
    num = Time.now.strftime("%Y%m%d%H%M%S")
    make_payment live_1, live_2, "make_payment test #{num}"
    make_payment live_2, live_1, "make_payment test #{num} reverse"
  end

  @@user_ids = {}
  @@user_tokens = {}
  def make_user num, get_id=true
    u = users("paypal_live_#{num}")
    if u.paypal.access_token == "TBAZ"
      @@user_tokens[num] ||= get_env("PAYPAL_ACCESS_TOKEN_#{num}")
      u.paypal.update_attribute(:access_token,
                                @@user_tokens[num])
    end
    puts u.paypal.inspect
    if get_id && !u.paypal.paypal_id
      unless @@user_ids[num]
        code, response = Payment::PayPal.me u.paypal
        assert 200, code
        @@user_ids[num] = response["data"]["user"]["id"]
      end
      u.paypal.update_attribute(:paypal_id, @@user_ids[num])
    end
    u
  end

  def make_payment user_1, user_2, note, amount=100
    transfer = Transfer.create transfer_params(user_1, user_2, amount, note)
    paypal = Payment::PayPal.create :transfer_id=>transfer.id
    code, response = paypal.make_payment
    assert_equal 200, code, "response = #{response.inspect}"
    assert response["data"]
    assert response["data"]["payment"]
    assert "settled", response["data"]["payment"]["status"]
  end

  def transfer_params src, dest, amount_cents, note="betuabuck test"
    {:user_id=>src.id,
      :recipient_id=>dest.id,
      :amount_cents=>amount_cents,
      :note=>note,
      :kind=>0
      }
  end

  def get_env x
    ENV[x] || raise("define environment variable: #{x}")
  end
end
