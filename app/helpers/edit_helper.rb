module EditHelper
  def edit_fields form, *opts, &block
    raise "missing form" unless form
    options = {}
    options.merge!(opts.pop) if opts && opts.last.is_a?(Hash)
    obj = opts.empty? ? nil : opts.shift
    content =
      (obj ? opts.map{|field| edit_field obj, field}.join('') : '').html_safe
    submit_options =
      {:format=>:submit, :class=>"btn btn-info form-control"}.merge!(options)
    submit = edit_field(form, nil, submit_options)
    if block_given?
      if @admin_page
        content_tag(:table, :class=>"edit-fields") do
          content.html_safe + capture(form, &block) + submit
        end
      else
        content.html_safe + capture(form, &block) + submit
      end
    else
      if @admin_page
        content_tag(:table, content.html_safe, :class=>"edit-fields") + submit
      else
        content.html_safe
      end
    end
  end

  def edit_field_errors obj, field
    return nil unless field && obj
    u = obj.errors[field]
    if u.empty?
      nil
    else
      content_tag(:div,
                  :id=>'error_explanation') do
        u.join("<br/>").html_safe
      end
    end
  end

  def edit_field_value form, field, options={}
    format = options[:format]
    if field == :password || field == :password_confirmation
      format||= :password_field
    end
    format ||= :text_field
    errors = edit_field_errors(form.object, field)
    case format
    when :submit
      form.submit(options[:label], :class=>options[:class]||'form-control')
    when :none
      ''.html_safe
    when:collection_select
      form.collection_select(field,
                             *options[:collection],
                             options[:options] || {},
                             :data=>options[:data],
                             :class=>options[:class]||'form-control')
    when :select
      form.select(field,
                  options_for_select(options[:select_options],
                                     form.object.send(field)),
                  options[:options] || {},
                  :data=>options[:data],
                  :class=>options[:class]||'form-control')
    when :file_field
      opts = {:class=>options[:class]||'form-control'}
      edit_file_field form, field, options[:placeholder] || "Upload", opts
    else
      opts = {:class=>options[:class]||'form-control'}
      opts[:placeholder] = options[:placeholder]
      form.send(format,
                field,
                opts)+errors
    end
  end

  def edit_file_field form, field, label, options
    content = content_tag(:span,label.html_safe,:class=>"msg") +
      form.file_field(field, options) +
      content_tag(:span, '', :class=>'filename')
    content_tag :span, content, :class=>"btn btn-default btn-file form-control"
  end

  def edit_field form, field, *opts
    if field.is_a?(Array)
      return raw field.map{|f| edit_field form, f, *opts}.join
    end
    options = {:label=>field && field.to_s.titleize,
    :label_class=>"show-label",
    :field_class=>"show-value"}
    options.merge!(opts.pop) if opts && opts.last.is_a?(Hash)
    value = opts.empty? ? edit_field_value(form, field, options) : opts.shift
    if @admin_page
      content_tag(:tr, :class=>"show-field edit-field-#{field}") do
        out = content_tag(:th, options[:label], :class=>options[:label_class])
        out << content_tag(:td,
                           value.to_s.html_safe,
                           :class=>options[:field_class])
      end
    else
      content_tag(:div, :class=>"row show-field edit-field-#{field}") do
        value.to_s.html_safe
      end
    end
  end

  def edit_field_simple form, field, *opts
    if field.is_a?(Array)
      return raw field.map{|f| edit_field_simple form, f, *opts}.join
    end
    options = {:placeholder=>field && field.to_s.titleize}
    options.merge!(opts.pop) if opts && opts.last.is_a?(Hash)
    value = opts.empty? ? edit_field_value(form, field, options) : opts.shift
    content_tag(:div,
                value.to_s.html_safe,
                :class=>"row show-field edit-field-#{field}")
  end

end
