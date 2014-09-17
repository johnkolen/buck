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
end
