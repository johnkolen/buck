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
    content_tag :div, :class=>"navbar navbar-default show_navigation", :role=>"navigation" do
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

  def any_navigation obj, *list_opts
    options = {}
    options.merge!(list_opts.pop) if list_opts && list_opts.last.is_a?(Hash)
    list_opts.unshift options[:second] ||  list_link(obj.class)
    list_opts.unshift options[:first] || show_link(obj)
    list_opts = list_opts.map {|x| content_tag(:li, x,:class=>options[:class]) }
    common_navigation list_opts, options
  end


end
