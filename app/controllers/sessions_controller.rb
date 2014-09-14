class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(:email=>params[:email])
    respond_to do |format|
      if @user && @user.credentials_ok?(:password=>params[:password])
        session.clear
        @user.signin session
        format.html { redirect_to dashboard_user_path(@user) }
      else
        session[:login_attempts] = (session[:login_attempts] || 0) + 1
        format.html { redirect_to :action=>:new }
      end
    end
  end

  def destroy
    if session[:saved_user_id]
      @user = User.find(session[:saved_user_id])
      @user.signin session
      redirect_to admin_users_path
    else
      session.clear
      redirect_to root_path
    end
  end

  def impersonate
  end

end
