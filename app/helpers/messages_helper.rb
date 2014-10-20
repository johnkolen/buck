module MessagesHelper
  def message_fields message
    user = message.user
    out = show_field(message, :from, user.full_name)
    out << show_field(message, :content)
  end

  def message_edit_fields form, *opts
    options = {}
    options.merge! opts.last if opts && opts.last.is_a?(Hash)
    if @admin_page
      out = edit_field form, :user_id
      out << edit_field(form, :content, :format=>:text_area)
    else
      out = edit_field form, :user_id
      out << edit_field(form, :content, :format=>:text_area)
    end
  end

end
