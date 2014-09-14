module UsersHelper
  def user_fields user
    show_field user, [:first_name, :last_name, :email, :created_at]
  end

  def user_edit_fields form
    edit_field form, [:first_name, :last_name, :email]
  end

  def password_credential_edit_fields form
    user = form.object
    credential = user.password_credential || user.credentials.build
    form.fields_for :credentials, credential do |cf|
      edit_field cf, [:password, :password_confirmation]
    end
  end

  def show_avatar user, size=nil
    image_tag "generic_avatar.png"
  end
end
