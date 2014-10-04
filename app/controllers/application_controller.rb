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
            sp.delete key
            result = result.where([clause, *vars])
          end
        end
        sp.keys.each do |key|
          result = result.where(["#{key} LIKE ?", "%#{sp[key]}%"])
        end
      end
    end
    result.paginate(:page=>params[:page], :per_page=>5)
  end

end
