module ShowHelper
  def show_fields *opts, &block
    options = {}
    options.merge!(opts.pop) if opts && opts.last.is_a?(Hash)
    obj = opts.empty? ? nil : opts.shift
    content =
      (obj ? opts.map{|field| show_field obj, field}.join('') : '').html_safe
    if block_given?
      content_tag(:table, :class=>"show-fields") do
        content.html_safe + capture(&block)
      end
    else
      content_tag(:table, content.html_safe, :class=>"show-fields")
    end
  end

  def show_field_value obj, field, options={}
    if /(.*)_id$/ =~ field.to_s
      obj_link(eval($1.classify), obj.send(field))
    elsif :email == field
      mail_to(obj.email, obj.email)
    elsif options[:format] == :literal
      options[:value]
    else
      obj.send(field)
    end
  end

  # first entry of opts is optional value
  def show_field obj, field, *opts
    if field.is_a?(Array)
      return raw field.map{|f| show_field obj, f, *opts}.join
    end
    options = {:label=>field.to_s.titleize,
    :label_class=>"show-label",
    :field_class=>"show-value"}
    options.merge!(opts.pop) if opts && opts.last.is_a?(Hash)
    value = opts.empty? ? show_field_value(obj, field, options) : opts.shift
    content_tag(:tr, :class=>"show-field show-field-#{field}") do
      out = content_tag(:th, options[:label], :class=>options[:label_class])
      out << content_tag(:td,
                         value.to_s.html_safe, :class=>options[:field_class])
    end
  end

end
