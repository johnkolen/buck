require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  def setup
    @transfer = Transfer.new
  end
  %w{completed failed canceled pending pending_accept}.each do |v|
    %w{user recipient}.each do |uc|
      test "is_#{uc}_#{v}?" do
        if v == 'completed'
          @transfer.pending!
        else
          @transfer.completed!
        end
        msg = "#{uc}_#{v}"
        assert_not @transfer.send("#{msg}?"), "before"
        @transfer.send("#{msg}!")
        assert @transfer.send("#{msg}?"), "after"
        assert @transfer.send("either_#{v}?"), "either"
      end
    end
    test "either_#{v}?" do
      if v == 'completed'
        @transfer.pending!
      else
        @transfer.completed!
      end
      state = @transfer.state
      msg = "either_#{v}?"
      assert_not @transfer.send(msg), "none"
      @transfer.send("user_#{v}!")
      assert @transfer.send(msg), "user"
      @transfer.state = state
      @transfer.send("recipient_#{v}!")
      assert @transfer.send(msg), "recipient"
      @transfer.send("user_#{v}!")
      assert @transfer.send(msg), "both"
    end
    test "#both_#{v}?" do
      if v == 'completed'
        @transfer.pending!
      else
        @transfer.completed!
      end
      state = @transfer.state
      msg = "both_#{v}?"
      assert_not @transfer.send(msg), "none"
      @transfer.send("user_#{v}!")
      assert_not @transfer.send(msg), "user"
      @transfer.state = state
      @transfer.send("recipient_#{v}!")
      assert_not @transfer.send(msg), "recipient"
      @transfer.send("user_#{v}!")
      assert @transfer.send(msg), "both"
    end
  end

  test "user options" do
    options = Transfer.user_state_options
    assert_equal 5, options.size
    assert_equal "User Completed", options.first.first
  end

  test "recipient options" do
    options = Transfer.recipient_state_options
    assert_equal 5, options.size
    assert_equal "Recipient Completed", options.first.first
  end

  test "user_state" do
    @transfer.state = 255
    @transfer.user_state=1
    assert @transfer.user_completed?
    @transfer.user_state=2
    assert @transfer.user_failed?
    @transfer.user_state=4
    assert @transfer.user_canceled?
    @transfer.user_state=8
    assert @transfer.user_pending?
  end

  test "recipient_state" do
    @transfer.state = 255
    @transfer.recipient_state=1
    assert @transfer.recipient_completed?
    @transfer.recipient_state=2
    assert @transfer.recipient_failed?
    @transfer.recipient_state=4
    assert @transfer.recipient_canceled?
    @transfer.recipient_state=8
    assert @transfer.recipient_pending?
  end
end
