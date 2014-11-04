class StaticPagesController < ApplicationController
  def root
    redirect_to dashboard_user_path(session[:user_id]) if session[:user_id]
  end

  def toc
  end

  def about
  end

  def admin
  end

  def coming_soon
    if params[:email]
      @user = User.where(:email=>params[:email]).first
      if @user && @user.is_admin?
        session.clear
        @user.signin session
        redirect_to admin_path
        return
      end
      @email_address = EmailAddress.create(:email=>params[:email])
    end
  end
end
