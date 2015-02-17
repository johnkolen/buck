module ButtonsHelper

  BUTTON_CLASS = "btn btn-md btn-info"
  def login_button
    link_to("Log In",
            "#sign-in-modal-id",
            :data => {:toggle => "modal"},
            :class => BUTTON_CLASS+" header-button")
  end

  def logout_button
    link_to("Log Out",
            sessions_destroy_path,
            :method => :delete,
            :class => BUTTON_CLASS + " header-button")
  end

  def new_button klass
    button_to("New #{klass.to_s}",
              new_polymorphic_path(klass),
              :method=>:get,
              :class=>"btn btn-info")
  end

  def back_button back
    button_to 'Back', back, :method=>:get
  end

  def list_button klass
    button_to 'List', polymorphic_path(klass), :method=>:get
  end

  def list_link klass
    link_to 'List', polymorphic_path(klass), :method=>:get
  end
  def show_link target, *opts
    h = {:label=>"Show"}
    h.merge!(opts.last) if opts && opts.last.is_a?(Hash)
    link_to h[:label], polymorphic_path(target, h), :method=>:get
  end
  def edit_link target
    link_to "Edit", edit_polymorphic_path(target), :method=>:get
  end
  def show_button target, *opts
    h = {}
    h.merge!(opts.last) if opts && opts.last.is_a?(Hash)
    if h.empty?
      content_tag :span, :class=>" btn-inline" do
        button_to("Show",
                  polymorphic_path(target),
                  :method=>:get, :class=>"btn btn-info")
      end
    else
      link_to "Show", polymorphic_path(target, h), :method=>:get
    end
  end
  def edit_button target
    content_tag :span, :class=>" btn-inline" do
      button_to("Edit",
                edit_polymorphic_path(target),
                :method=>:get,
                :class=>"btn btn-info")
    end
  end

  def destroy_button target
    content_tag :span, :class=>" btn-inline" do
      button_to("Destroy",
                polymorphic_path(target),
                :method =>:delete,
                :class=>"btn btn-info",
                :data =>{ :confirm => 'Are you sure?' })
    end
  end

  def sed_buttons obj
    space = " ".html_safe
    show_button(obj) + space +
      edit_button(obj) + space +
      destroy_button(obj)
  end

  def signup_button
    button_to("Signup",
              new_user_path,
              :method=>:get,
              :class=>"form-control btn btn-info")
  end

  def login_button
    button_to("Log In",
              sessions_new_path,
              :method=>:get,
              :class=>"form-control btn btn-info")
  end

  def logout_button
    link_to("Log Out",
            sessions_destroy_path,
            :method => :delete,
            :class=>"form-control btn btn-info")
  end

  def header_logout_link
    link_to("Log Out",
            sessions_destroy_path,
            :method => :delete,
            :class=>"")
  end

  def admin_link
    link_to("Admin",
            admin_path,
            :class=>"")
  end
  def admin_button
    button_to("Admin",
              admin_path,
              :method=>:get,
              :class=>BUTTON_CLASS)
  end

  def edit_profile_button user
    link_to("Edit Profile", edit_user_path(user), :class=>BUTTON_CLASS)
  end

  def dashboard_close_button transfer
    button_to("&times;".html_safe,
              off_dashboard_transfer_path(transfer),
              :class=>"close",
              :remote=>true)

  end

  def glyph label
    content_tag(:span,'',:class=>"glyphicon glyphicon-#{label}")
  end

  def edit_comment_button comment
    button_to(edit_comment_path(comment),
              :class=>"close",
              :method=>"get",
              :remote=>true) do
      glyph(:pencil)
    end
  end

  def ok_transfer_button transfer
    button_to("OK",
              complete_transfer_path(transfer),
              :class=>BUTTON_CLASS,
              :remote=>true)
  end

  def accept_transfer_button transfer
    button_to("Accept",
              accept_transfer_path(transfer),
              :class=>BUTTON_CLASS,
              :remote=>true)
  end

  def cancel_transfer_button transfer
    button_to("Cancel",
              cancel_transfer_path(transfer),
              :class=>BUTTON_CLASS,
              :remote=>true)
  end

  def fail_transfer_button transfer
    button_to("Fail",
              fail_transfer_path(transfer),
              :class=>BUTTON_CLASS,
              :remote=>true)
  end

  def forgot_password_button
    link_to("Forgot Password",
            forgot_password_users_path,
            :class=>"btn btn-info center-block")
  end
  def home_link
    link_to("Home", dashboard_user_path(session[:user_id]), :method=>:get)
  end
  def hot_link
    link_to("Hot", hot_path, :method=>:get)
  end
  def friends_link
    link_to("Friends", friends_user_path(session[:user_id]), :method=>:get)
  end
  def featured_link
    link_to("Featured", featured_path, :method=>:get)
  end
  def sponsored_link
    link_to("Sponsored", sponsored_path, :method=>:get)
  end
  def donate_link
    link_to("Donate", featured_path, :method=>:get)
  end
  def recent_link
    link_to "Recent", recent_transfers_path, :method=>:get
  end
  def logout_link
    link_to "Logout", sessions_destroy_path, :method => :delete
  end

  def send_bucks_button user
    link_to("Send Bucks",
            "#",
            :class=>"form-control btn btn-info send-bucks-button",
            :data=>{:id=>user.id,:name=>user.full_name})
  end
  def return_to_login_button
    button_to("Return to Log In",
              sessions_new_path,
              :method=>:get,
              :class=>"form-control btn btn-info")
  end
  def venmo_button user
    link_to(image_tag("venmo/venmo_logo_white.png"),
            Payment::Venmo.authorize_url(user, dashboard_user_path(user)),
            :class=>"btn-venmo btn")
  end
  def paypal_button user
    img = image_tag("https://www.paypalobjects.com" +
                    "/webstatic/en_US/btn/btn_pponly_142x27.png")
    link_to(img,
            Payment::PayPal.authorize_url(user, dashboard_user_path(user)),
            :class=>"btn-venmo btn")
  end
  def modal_button target, msg
    content_tag(:button,
                msg,
                :id=>"#{target}_modal_button",
                :class=>"btn btn-default btn-info",
                :data=>{:toggle=>"modal", :target=>"##{target}_modal"})
  end

  def invitation_modal_button
    modal_button 'invitation', "Invite"
  end

  def settlement_modal_button
    modal_button('settlement', "Settle Up!")
  end

  def payment_approval_button
    urls = Payment::PayPal.approval_urls @current_user.payments_for_approval
    img = image_tag "https://www.paypalobjects.com/en_US/i/btn/x-click-but6.gif"
    link_to img, urls.first
  end

  def cancel_profile_button
    link_to("Cancel Edit",
              user_path(@current_user),
              :class=>"btn btn-default btn-info center-block")
  end
end
