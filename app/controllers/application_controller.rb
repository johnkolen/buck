class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :select_layout

  before_action :admin_page
  before_action :find_current_user

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

  def find_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
end
