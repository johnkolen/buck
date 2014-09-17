class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :select_layout

  before_action :admin_page

  def admin_page
    @admin_page = request.path.index("/admin") == 0
    redirect_to root_path if @admin_page && !session[:is_admin]
    true
  end

  def select_layout
    if @admin_page
      "admin"
    else
      "application"
    end
  end
end
