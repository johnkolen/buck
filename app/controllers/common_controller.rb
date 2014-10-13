class CommonController < ApplicationController
  before_action :set_user
  before_action :check_validation
  before_action :check_temporary_password

  def hot
  end

  def featured
    @transfers = Transfer.recent
  end

  def sponsored
  end

  def donate
  end

  protected
  def set_user
    @user = User.find(session[:user_id])
  end
end
