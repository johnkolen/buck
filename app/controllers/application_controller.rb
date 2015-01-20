class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :select_layout

  before_action :coming_soon_check
  before_action :admin_page
  before_action :find_current_user

  def coming_soon_check
    return
    unless session[:user_id]
      if Rails.env == "production" && params[:action] != "coming_soon"
        redirect_to coming_soon_path unless ENV["HEROKU_POSTGRESQL_BLACK_URL"]
      end
    end
  end

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
  rescue ActiveRecord::RecordNotFound
    redirect_to logout_path if session[:user_id]
  end

  def ensure_venmo
    return unless Rails.application.config.payment_vendor == :venmo

    if @current_user &&
        !(/localhost/ =~ request.original_url) &&
        !session[:venmo_page] &&
        (!@current_user.venmo || @current_user.venmo.declined?)
      url = Payment::Venmo.authorize_url @current_user, request.original_url
      session[:venmo_page] = true
      redirect_to url
    end
  end

  def paged_search klass
    result = klass
    sp = (params[:search] || {}).dup

    if params[:commit]=="Reset"
      params.delete(:search)
    else
      if sp.is_a?(Hash)
        [:first_name,:last_name].each do |key|
          unless sp[key].blank?
            clause = "#{key} LIKE ?"
            vars = ["%#{sp[key]}%"]
            if result.table_name == 'transfers'
              clause = "users.#{clause} OR recipients_transfers.#{key} LIKE ?"
              vars.push vars.first
            end
            result = result.where([clause, *vars])
          end
          sp.delete key
        end
        sp.keys.each do |key|
          result = result.where(["#{key} LIKE ?", "%#{sp[key]}%"])
        end
      end
    end
    result.paginate(:page=>params[:page], :per_page=>5)
  end

  def check_validation
    if @current_user.validation
      redirect_to pending_validation_user_path(@current_user)
    end
  end

  def check_temporary_password
    c = @current_user.password_credential
    redirect_to change_password_user_path(@current_user) if c && c.temporary?
  end
end
