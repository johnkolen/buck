module PaginationHelper
  def paged_search_field x, sp
    field = "search[#{x}]"
    case x
    when :category
      sql = Message.select(:category).group(:category)
      options = options_from_collection_for_select(sql,
                                                   :category,
                                                   :category,
                                                   sp[x])
      select_tag(field, options, :prompt=>"Category", :class=>"form-control")
    when nil
      ''
    else
      text_field_tag(field, sp[x], :placeholder=>x.to_s.humanize,:class=>"form-control")
    end.html_safe
  end

  def paged_search_header path, objects, *opts
    options = {:method=>:get}
    if opts
      options.merge! opts.pop if opts[-1].is_a?(Hash)
      opts.each { |x| options[x] = true }
    end
    sp = params[:search] || {}
    ajax = options[:wp] && options[:wp].delete(:ajax)
    if options[:wp]
      options[:wp][:class] = 'ajaxpagination' if ajax
    end
    method = options.delete :method
    out = ''.html_safe
    unless options.empty?
      out << content_tag(:div, :class=>"row page-search") do
        form_tag path, :method=>method, :remote=>ajax, :class=>"form-inline" do
          f = options.map { |x,v| paged_search_field(x, sp) }
          unless f.empty?
            f.push submit_tag('Go',:class=>"btn btn-info")
            f.push submit_tag('Reset',:class=>"btn btn-info")
          end
          f.map { |x| content_tag(:div, x.html_safe, :class=>"form-group") }.join("\n".html_safe)
            .html_safe
        end
      end
    end
    out << will_paginate( *([objects, options.delete(:wp)].compact),
                          renderer: BootstrapPagination::Rails)
  end

end
