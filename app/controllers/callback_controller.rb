class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_venmo
  def venmo
    if params[:state]
      if /(\d+),(.+)/ =~ params[:state]
        user = begin User.find $1; rescue nil; end
        destination = $2
        if user
          if params[:code]
            Payment::Venmo.update_access_token user, params[:code]
          elsif /User.denied.your.application.access/ =~ params[:error]
            if user.venmo
              user.venmo.update_attributes(:declined=>true, :access_token=>nil)
            else
              user.venmo_users.create(:declined=>true)
            end
            redirect_to venmo_declined_path
            return
          end
          redirect_to destination
          return
        end
      end
      redirect_to root_path
    end
    if params[:venmo_challenge]
      render :text=>params[:venmo_challenge]
      return
    end
    render :nothing=>true
  end
end
