module TransfersHelper
  def transfer_fields transfer
    user = transfer.user
    out = show_field transfer, [:user_id, :recipient_id]
    out << show_field(transfer, :amount, number_to_currency(transfer.amount))
    out << show_field(transfer,
                      :created_at,
                      transfer.created_at_tz)
    out << show_field(transfer, :note)
  end

  def transfer_edit_fields form
    if @admin_page
      edit_field form, [:user_id, :recipient_id, :amount, :note]
    else
      transfer_amounts =
        [1,2,3,4,5].map{|v| [number_to_currency(v), v]}
      out = form.hidden_field(:user_id)
      transfer = form.object
      query = User.where.not(:id=>transfer.user_id)
      out << edit_field_simple(form,
                               :recipient_id,
                               :format=>:collection_select,
                               :collection=>[query,
                                             :id,
                                             :full_name],
                               :options=>{:prompt=>"Recipient"})
      out << edit_field_simple(form,
                               :amount,
                               :format=>:select,
                               :select_options=>transfer_amounts)
      out << edit_field_simple(form, :note, :placeholder=>"Why?")
    end
  end
end
