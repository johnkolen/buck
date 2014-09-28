require 'test_helper'

class TransfersHelperTest < ActionView::TestCase
  include TransfersHelper
  include ButtonsHelper

  def setup
    @transfer = transfers(:alan2bob)
  end

  test "pay completed" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    assert_equal COLOR_OUT, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_IN, transfer_color(@transfer), "recp view"
  end

  test "pay canceled" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "recp view"
  end

  test "pay pending accept" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_completed!
    @transfer.recipient_pending_accept!
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  ################

  test "request completed" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    assert_equal COLOR_IN, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_OUT, transfer_color(@transfer), "recp view"
  end

  test "request canceled" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "recp view"
  end

  test "request pending accept" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_completed!
    @transfer.recipient_pending_accept!
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  ################

  test "bet completed" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    assert_equal COLOR_OUT, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_IN, transfer_color(@transfer), "recp view"
  end

  test "bet failed" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_failed!
    @transfer.recipient_failed!
    user_view
    assert_equal COLOR_IN, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_OUT, transfer_color(@transfer), "recp view"
  end

  test "bet canceled" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "recp view"
  end

  test "bet pending accept" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_completed!
    @transfer.recipient_pending_accept!
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  test "bet pending" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_pending!
    @transfer.recipient_pending!
    assert @transfer.user_pending?
    assert @transfer.recipient_pending?
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  ################

  test "pledge completed" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    assert_equal COLOR_OUT, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_IN, transfer_color(@transfer), "recp view"
  end

  test "pledge canceled" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_CANCEL, transfer_color(@transfer), "recp view"
  end

  test "pledge pending accept" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_completed!
    @transfer.recipient_pending_accept!
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  test "pledge pending" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_pending!
    @transfer.recipient_pending!
    user_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "user view"
    recp_view
    assert_equal COLOR_ACK, transfer_color(@transfer), "recp view"
  end

  ################

  test "transfer actions pay completed" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions pay canceled" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions pay pending accept" do
    @transfer.kind = Transfer::KIND_PAY
    @transfer.user_pending!
    @transfer.recipient_pending_accept!
    user_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Accept/, result
  end

  #####################################################################

  test "transfer actions request completed" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions request canceled" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_canceled!
    @transfer.recipient_canceled!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions request pending accept" do
    @transfer.kind = Transfer::KIND_REQUEST
    @transfer.user_pending!
    @transfer.recipient_pending_accept!
    user_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_no_match /Accept/, result
    assert_no_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Accept/, result
    assert_no_match /OK/, result
  end

  #####################################################################

  test "transfer actions bet completed" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions bet user canceled" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_canceled!
    @transfer.recipient_pending!
    assert @transfer.user_canceled?, "rv = #{@transfer.user_canceled?.inspect}"
    user_view
    result = transfer_actions @transfer
    assert_match /#{CANCEL_MSG}/, result
    assert_no_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /wants to cancel/, result
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  test "transfer actions bet recp canceled" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_pending!
    @transfer.recipient_canceled!
    user_view
    result = transfer_actions @transfer
    assert_match /wants to cancel/, result
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /#{CANCEL_MSG}/, result
    assert_no_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  test "transfer actions bet pending" do
    @transfer.kind = Transfer::KIND_BET
    @transfer.user_pending!
    @transfer.recipient_pending!
    user_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  #####################################################################

  test "transfer actions pledge completed" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_completed!
    @transfer.recipient_completed!
    user_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
    recp_view
    result = transfer_actions @transfer
    assert result.to_s.empty?
  end

  test "transfer actions pledge user canceled" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_canceled!
    @transfer.recipient_pending!
    assert @transfer.user_canceled?, "rv = #{@transfer.user_canceled?.inspect}"
    user_view
    result = transfer_actions @transfer
    assert_match /#{CANCEL_MSG}/, result
    assert_no_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /wants to cancel/, result
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  test "transfer actions pledge recp canceled" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_pending!
    @transfer.recipient_canceled!
    user_view
    result = transfer_actions @transfer
    assert_match /wants to cancel/, result
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /#{CANCEL_MSG}/, result
    assert_no_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  test "transfer actions pledge pending" do
    @transfer.kind = Transfer::KIND_PLEDGE
    @transfer.user_pending!
    @transfer.recipient_pending!
    user_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
    recp_view
    result = transfer_actions @transfer
    assert_match /Cancel/, result
    assert_match /Fail/, result
    assert_match /OK/, result
  end

  #####################################################################
  def user_view
    session[:user_id] = @transfer.user_id
  end

  def recp_view
    session[:user_id] = @transfer.recipient_id
  end
end
