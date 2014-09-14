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
      content_tag(:table, :class=>"edit-fields") do
        content.html_safe + capture(form, &block) + submit
      end
    else
      content_tag(:table, content.html_safe, :class=>"edit-fields") + submit
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
    format = options[:format] || :text_field
    errors = edit_field_errors(form.object, field)
    if  format == :submit
      form.submit(options[:label], :class=>options[:class]||'form-control')
    elsif format == :collection_select
      form.collection_select(field, *(options[:collection]))
    elsif format == :select
      form.select(field,
                  options_for_select(options[:select_options],
                                     form.object.send(field)))
    else
      form.send(format,
                field,
                :class=>options[:class]||'form-control')+errors
    end
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
    content_tag(:tr, :class=>"show-field edit-field-#{field}") do
      out = content_tag(:th, options[:label], :class=>options[:label_class])
      out << content_tag(:td,
                         value.to_s.html_safe,
                         :class=>options[:field_class])
    end
  end

end
