module NavigationHelper
  # bottom of page navigation

  def show_navigation obj, *list_opts
    options = {}
    options.merge!(list_opts.pop) if list_opts && list_opts.last.is_a?(Hash)
    list_opts.unshift options[:second] ||  list_link(obj.class)
    list_opts.unshift options[:first] || edit_link(obj)
    list_opts = list_opts.map {|x| content_tag(:li, x,:class=>options[:class]) }
    common_navigation list_opts, options
  end

  def common_navigation list, options
    content_tag :div, :class=>"common_navigation" do
    content_tag :div, :class=>"#{options[:nav_class]} navbar navbar-default", :role=>"navigation" do
     content_tag :div, :class=>"container" do
        content_tag :ul, list.join.html_safe, :class=>"nav navbar-nav"
     end
    end
    end
  end

  def edit_navigation obj, *list_opts
    options = {:second=>list_link(obj.class)}
    options[:first] = show_link(obj) if obj.persisted?

    options.merge!(list_opts.pop) if list_opts && list_opts.last.is_a?(Hash)
    list_opts.unshift options[:second]
    list_opts.unshift options[:first]
    list_opts.compact!

    list_opts = list_opts.map {|x| content_tag(:li, x,:class=>options[:class]) }
    common_navigation list_opts, options
  end

  def user_navigation *opts
    options = {:nav_class=>"user_navigation"}
    options.merge! opts.last if opts && opts.last.is_a?(Hash)
    destinations = [home_link, hot_link, friends_link, featured_link]
    li_list =
      destinations.map {|x| content_tag(:li, x,:class=>options[:class]) }
    common_navigation li_list, options
  end

  def user_navigation *opts
    options = {
      :nav_class=>"user_navigation",
      :destinations=>[home_link, hot_link, friends_link, featured_link]
    }
    options.merge! opts.last if opts && opts.last.is_a?(Hash)
    li_list = options[:destinations].map do |x|
      content_tag(:li, x,:class=>options[:class])
    end
    common_navigation li_list, options
  end

  def any_navigation obj, *list_opts
    options = {}
    options.merge!(list_opts.pop) if list_opts && list_opts.last.is_a?(Hash)
    list_opts.unshift options[:second] ||  list_link(obj.class)
    list_opts.unshift options[:first] || show_link(obj)
    list_opts = list_opts.map {|x| content_tag(:li, x,:class=>options[:class]) }
    common_navigation list_opts, options
  end

  def admin_navigation_menu
    items = []

    items << ["Site", root_path]

    [Admin::User,
     Admin::Transfer].each do |klass|
      if klass.is_a?(Class)
        items << [klass.to_s.pluralize.gsub!('Admin::',''),
                  polymorphic_path(klass)]
      else
        items << klass
      end
    end


    content_tag :ul, :class=>"sidebar-nav" do
      items.map { |label,path|
        content_tag(:li,content_tag(:div,link_to(label, path)))
      }.join.html_safe
    end
  end

end
