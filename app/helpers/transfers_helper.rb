module TransfersHelper
  def transfer_fields transfer
    user = transfer.user
    out = show_field transfer, [:user_id, :recipient_id]
    out << show_field(transfer, :amount, number_to_currency(transfer.amount))
    out << show_field(transfer,
                      :created_at,
                      transfer.created_at_tz)
    out << show_field(transfer,
                      :updated_at,
                      transfer.updated_at)
    out << show_field(transfer,
                      :comments,
                      transfer.comments.count)
    out << show_field(transfer,
                      :comment_at,
                      transfer.comment_at)
    out << show_field(transfer, :note)
    out << show_field(transfer, :kind, transfer.kind_str)
    out << show_field(transfer, :state, transfer.state_str)
    out << show_field(transfer, :image, image_tag(transfer.image.url(:medium)))
  end

  def transfer_edit_fields form
    if @admin_page
      out = edit_field form, [:user_id, :recipient_id, :amount, :note]
      image_label =
        params[:action] == "edit" ? "Update Picture" : "Upload Picture"
      out << edit_field(form,
                        :image,
                        :placeholder=>image_label,
                        :format=>:file_field)
      out << edit_field(form,
                        :kind,
                        :format=>:select,
                        :select_options=>Transfer.kind_options)
      out << edit_field(form,
                        :user_state,
                        :format=>:select,
                        :select_options=>Transfer.user_state_options)
      out << edit_field(form,
                        :recipient_state,
                        :format=>:select,
                        :select_options=>Transfer.recipient_state_options)
    else
      transfer_amounts =
        [1,2,3,4,5].map{|v| [number_to_currency(v), v]}
      out = form.hidden_field(:user_id)
      transfer = form.object
      query = User.where.not(:id=>transfer.user_id)
      out << edit_field_simple(form,
                               :kind,
                               :format=>:select,
                               :select_options=>Transfer.kind_options)
      out << edit_field_simple(form,
                               :recipient_id,
                               :format=>:collection_select,
                               :collection=>[query,
                                             :id,
                                             :full_name],
                               :options=>{:prompt=>"Recipient?"})
      out << edit_field_simple(form,
                               :amount,
                               :format=>:select,
                               :select_options=>transfer_amounts)
      out << edit_field_simple(form, :note, :placeholder=>"For?")
      image_label =
        params[:action] == "edit" ? "Update Picture" : "Upload Picture"
      out << edit_field(form,
                        :image,
                        :placeholder=>image_label,
                        :format=>:file_field)
    end
  end

  COLOR_OUT = "bg-danger"
  COLOR_IN = "bg-success"
  COLOR_ACK = "bg-warning"
  COLOR_BET = "bg-info"
  COLOR_CANCEL = "bg-cancel"

  def completed_color transfer
    if transfer.user_id == session[:user_id]
      COLOR_OUT
    else
      COLOR_IN
    end
  end

  def completed_color_reverse transfer
    if transfer.user_id == session[:user_id]
      COLOR_IN
    else
      COLOR_OUT
    end
  end

  def transfer_color transfer
    return COLOR_CANCEL if transfer.canceled?
    return COLOR_ACK if transfer.pending? || transfer.recipient_pending_accept?
    if transfer.is_request?
      completed_color_reverse transfer
    elsif transfer.is_pending_bet? || transfer.is_pending_pledge?
      COLOR_BET
    elsif transfer.is_failed_bet?
      completed_color_reverse transfer
    else
      completed_color transfer
    end
  end

  def transfer_ack_actions transfer
    out = cancel_transfer_button(transfer)
    if transfer.recipient_id == session[:user_id]
      out = accept_transfer_button(transfer) + out
    end
    out
  end

  def ta_message msg
    content_tag(:div, msg, :class=>"message")
  end

  CANCEL_MSG = "Your cancel request is pending."
  FAIL_MSG = "Your failure request is pending."
  COMPLETE_MSG = "Your completion request is pending."

  def transfer_actions transfer
    return if transfer.completed?
    return if transfer.canceled?

    content_tag(:div,:class=>"transfer-actions") do
      if transfer.is_pay? || transfer.is_request?
        transfer_ack_actions transfer
      elsif transfer.is_bet? || transfer.is_pledge?
        out = []
        name = transfer.user.first_name
        #puts "#{transfer.inspect} == #{session[:user_id]}"
        if transfer.recipient_id == session[:user_id]
          if transfer.user_canceled?
            out << ta_message("#{name} wants to cancel.".html_safe)
            #out << reject_cancel_transfer_button(transfer)
            out << cancel_transfer_button(transfer)
          elsif transfer.recipient_canceled?
            out << ta_message(CANCEL_MSG)
          else
            out << cancel_transfer_button(transfer)
          end
          if transfer.recipient_pending_accept?
            out << accept_transfer_button(transfer)
          else
            if transfer.user_failed?
              msg = "#{name} says you failed. Click 'Fail' if you aggree"
              out.unshift ta_message(msg)
            end
            if transfer.recipient_failed?
              out.unshift ta_message(FAIL_MSG)
            else
              out << fail_transfer_button(transfer)
            end
            if transfer.user_completed?
              msg = "#{name} says you completed. Click 'OK' if you aggree"
              out.unshift ta_message(msg)
            end
            if transfer.recipient_completed?
              out.unshift ta_message(COMPLETE_MSG)
            else
              out << ok_transfer_button(transfer)
            end
          end
        elsif transfer.user_id == session[:user_id]
          if transfer.recipient_canceled?
            name = transfer.recipient.first_name
            out << ta_message("#{name} wants to cancel.".html_safe)
            #out << reject_cancel_transfer_button(transfer)
            out << cancel_transfer_button(transfer)
          elsif transfer.user_canceled?
            out << ta_message(CANCEL_MSG)
          else
            out << cancel_transfer_button(transfer)
          end
          if transfer.user_pending_accept?
            out << accept_transfer_button(transfer)
          else
            if transfer.recipient_failed?
              msg = "#{name} admits failure. Click 'Fail' if you aggree"
              out.unshift ta_message(msg)
            end
            if transfer.user_failed?
              out.unshift ta_message(FAIL_MSG)
            else
              out << fail_transfer_button(transfer)
            end
            if transfer.recipient_completed?
              msg = "#{name} claims success. Click 'OK' if you aggree"
              out.unshift ta_message(msg)
            end
            if transfer.user_completed?
              out.unshift ta_message(COMPLETE_MSG)
            else
              out << ok_transfer_button(transfer)
            end
          end

        end
        safe_join out
      end
    end
  end
end
