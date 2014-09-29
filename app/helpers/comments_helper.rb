module CommentsHelper
  def comment_fields comment
    out = show_field comment, :note
    out << show_field(comment, :image, image_tag(transfer.image.url(:medium)))
    out << show_field(comment, :created_at)
  end

  def comment_edit_fields form
    if @admin_page
      out = edit_field form, :note, :format=>:text_area
      image_label =
        params[:action] == "edit" ? "Update Picture" : "Upload Picture"
      out << edit_field(form,
                        :image,
                        :placeholder=>image_label,
                        :format=>:file_field)
    else
      out = edit_field_simple form, :note, :format=>:text_area
      image_label =
        params[:action] == "edit" ? "Update Picture" : "Upload Picture"
      out << edit_field(form,
                        :image,
                        :placeholder=>image_label,
                        :format=>:file_field)
    end
  end
end
