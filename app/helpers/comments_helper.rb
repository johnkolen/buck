module CommentsHelper
  def comment_fields user
    out = show_field user, [:note, :created_at]
  end

  def comment_edit_fields form
    if @admin_page
      edit_field form, :note, :format=>:text_area
    else
      edit_field_simple form, :note, :format=>:text_area
    end
  end
end
