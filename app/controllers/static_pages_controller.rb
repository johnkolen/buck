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
      @email_address = EmailAddress.create(:email=>params[:email])
    end
  end
end
