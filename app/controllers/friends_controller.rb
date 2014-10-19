class FriendsController < ApplicationController
  def add
    raise "missing user" unless session[:user_id]
    raise "missing friend" unless params[:id]
    UserFriend.find_or_create_by(:user_id=>session[:user_id],
                                 :friend_id=>params[:id])
    respond_to do |format|
      format.js
    end
  end

  def remove
    @uf = UserFriend.where(:user_id=>session[:user_id],
                           :friend_id=>params[:id]).first
    @uf.destroy if @uf
    respond_to do |format|
      format.js
    end
  end
end
