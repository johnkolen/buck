module UsersHelper
  def user_fields user
    out = show_field user, [:first_name, :last_name, :email]
    out << show_field(user, :is_admin) if @admin_page
    out << show_field( user, [:time_zone, :created_at])
  end

  def user_edit_fields form
    time_zones = ActiveSupport::TimeZone.us_zones.map{|x| x.name}
    if @admin_page
      out = edit_field form, [:first_name, :last_name, :email]
      out << edit_field(form,
                        :time_zone,
                        :format=>:select,
                        :select_options=>time_zones)
      out << edit_field(form, :is_admin, :format=>:check_box)
    else
      out = edit_field_simple form, [:first_name, :last_name, :email]
      out << edit_field_simple(form,
                        :time_zone,
                        :format=>:select,
                        :select_options=>time_zones)
    end
  end

  def password_credential_edit_fields form
    user = form.object
    credential = user.password_credential || user.credentials.build
    form.fields_for :credentials, credential do |cf|
      if @admin_page
        edit_field cf, [:password, :password_confirmation]
      else
        edit_field_simple cf, [:password, :password_confirmation]
      end
    end
  end

  def show_avatar user, size=nil
    image_tag "generic_avatar.png"
  end
end
