class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_paypal

  def paypal
    Payment::PayPal.process_ipn params
    render :nothing=>true
  end

  def paypal_return
    # on successful completion of transaction send user to dashboard
    if @current_user
      redirect_to dashboard_user_path(@current_user)
    else
      redirect_to :root
    end
  end

  def paypal_auth
    if params[:error]
      redirect_to :root
      return
    end
    if /(\d+),(.+)/ =~ params[:state]
      user = begin User.find $1; rescue nil; end
      destination = $2
      if params[:code]
        Payment::PayPal.update_access_token user, params[:code]
      else
        user.paypal_users.create(:declined=>true, :access_token=>nil)
        redirect_to paypal_declined_path
      end
      redirect_to destination
      return
    end
    render :nothing=>true
  end

  def paypal_cancel
    redirect_to dashboard_user_path(@current_user)
  end

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


