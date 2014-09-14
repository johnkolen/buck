class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :select_layout

  def select_layout
    if request.path.index("/admin/") == 0
      @admin_page = true
      "admin"
    else
      "application"
    end
  end
end
