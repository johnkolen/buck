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
end
