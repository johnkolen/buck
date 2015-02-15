require 'test_helper'
require 'mocha/test_unit'

class Payment::PayPalTest < ActiveSupport::TestCase
  test "user_agent" do
    ua = PayPal::SDK::OpenIDConnect::API.user_agent
  end
  test "authorize url" do
    user = users(:alan)
    p = Payment::PayPal.authorize_url user
    assert /state=#{user.id}/ =~ p, "no state: #{p}"
    assert /response_type=/ =~ p
    assert /client_id=/ =~ p
    assert /nonce=/ =~ p
  end
  test "update_access_token" do
    user = users(:alan)
    ti = PayPal::SDK::OpenIDConnect::Tokeninfo.new sample_tokeninfo
    Payment::PayPal.expects(:create_tokeninfo).returns(ti)
    assert_difference "PaypalUser.count" do
      Payment::PayPal.update_access_token user, "some_auth_code"
    end
  end

  test "update_access_token twice" do
    user = users(:alan)
    ti = PayPal::SDK::OpenIDConnect::Tokeninfo.new sample_tokeninfo
    Payment::PayPal.expects(:create_tokeninfo).returns(ti)
    user.paypal_users.create
    assert_no_difference "PaypalUser.count" do
      Payment::PayPal.update_access_token user, "some_auth_code"
    end
    assert_equal sample_tokeninfo["access_token"], user.paypal.access_token
  end

  test "payments" do
    #puts Payment::PayPal.payments.inspect
  end

  def sample_tokeninfo
    {"access_token"=>"A015t620lAo5lpbsVgrqB5QKlAYdkbSITAxm.nTiDQZdbbs",
      "refresh_token"=>"TiXnNsi0W76goq4UgsYeBq31HZVqSxmxMDMx6eyWG8B90kYvlY5Abfc9Ca_1B08WBwRVSMvlABD4eTxXKh44HHlSacBHSaoPInOyADFiTxslbEWWxfNEWA2FgjM",
      "token_type"=>"Bearer",
      "id_token"=>"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJBUnJlSmhDYl9XbkgwbnNpRDlyajVMNFlEWjRWTDZMTUd0c3c0dUU5MGRLVHVXUlR0bHlSTFdNTmJPSHoiLCJhdXRoX3RpbWUiOjE0MjM0MjI1ODMsImlzcyI6Imh0dHBzOi8vd3d3LnBheXBhbC5jb20iLCJzZXNzaW9uSW5kZXgiOiI1ZTYyN2NhM2ExNmI1ZTAyZmVlYTU0NDk2Y2I3YzI0NTA1ZDNhNDA0IiwiaWF0IjoxNDIzNDIyNTg3LCJleHAiOjI4ODAwLCJub25jZSI6Ik1DNDVNVGd3TURnME1qVXlNVFl6TURrNFxuIiwidXNlcl9pZCI6Imh0dHBzOi8vd3d3LnBheXBhbC5jb20vd2ViYXBwcy9hdXRoL2lkZW50aXR5L3VzZXIveF9iVzY2UjM3SlhlYURZTUROSFp1Y1BLLWJwUG5LM3A1LTFoblk3MGxZWSJ9.9vzbGQJDI76bXqcCxvC5DzZppB2UKTc_qZ4V6u_F6CM",
      "expires_in"=>28800
    }
  end

  def sample_ipn
    {"transaction"=>{
        "0"=>{
          ".invoiceId"=>"test 6 [31]",
          ".id_for_sender_txn"=>"37T02728R3072452R",
          ".receiver"=>"paypal_test_2@betuabuck.com",
          ".is_primary_receiver"=>"false",
          ".id"=>"2E432864FL1402025",
          ".status"=>"Completed",
          ".paymentType"=>"PERSONAL",
          ".status_for_sender_txn"=>"Completed",
          ".pending_reason"=>"NONE",
          ".amount"=>"USD 1.00"
        }
      },
      "payment_request_date"=>"Sat Feb 14 15:38:03 PST 2015",
      "return_url"=>"https://betuabuck.ngrok.com/callback/paypal_return",
      "fees_payer"=>"SENDER",
      "ipn_notification_url"=>"https://betuabuck.ngrok.com/callback/paypal",
      "sender_email"=>"paypal_test_1@betuabuck.com",
      "verify_sign"=>"AFcWxV21C7fd0v3bYYYRCpSSRl31Ajb5AXoGhXq8N09y7eHPU.Jv0wx8",
      "test_ipn"=>"1",
      "cancel_url"=>"https://betuabuck.ngrok.com/callback/paypal_cancel",
      "pay_key"=>"AP-5WP45424YY466815U",
      "action_type"=>"PAY",
      "memo"=>"Bet U A Buck Transfer",
      "transaction_type"=>"Adaptive Payment PAY",
      "status"=>"COMPLETED",
      "log_default_shipping_address_in_transaction"=>"false",
      "charset"=>"Shift_JIS",
      "notify_version"=>"UNVERSIONED",
      "reverse_all_parallel_payments_on_error"=>"false"
    }
  end
end

