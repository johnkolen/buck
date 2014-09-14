class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :select_layout

  before_action :admin_page

  def admin_page
    @admin_page = request.path.index("/admin/") == 0
  end

  def select_layout
    if request.path.index("/admin/") == 0
      "admin"
    else
      "application"
    end
  end
end
