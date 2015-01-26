module InvitationsHelper
  def invitation_edit_fields form
    out = edit_field_simple form, :email, :format=>:email_field
  end
  def invitation_list objs
    content_tag(:div, :class=>"invitation-list") do
      safe_join objs.map{|x| invitation_list_element(x)}
    end
  end
  def invitation_list_element obj
    msg = "#{obj.email} (#{obj.msg_count}) #{obj.signup_at || 'pending'}"
    content_tag(:div, msg.html_safe)
  end
end
