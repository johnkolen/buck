module UsersHelper
  def user_fields user
    show_field user, [:first_name, :last_name, :email, :created_at]
  end

  def user_edit_fields form
    edit_field form, [:first_name, :last_name, :email]
  end

  def show_avatar user, size=nil
    image_tag "generic_avatar.png"
  end
end
