module ApplicationHelper
  def app_name
    "Bet U A Buck"
  end

  def logo size
    img = image_tag("logo_x-large.png", :class=>"img-responsive", :alt=>app_name)
    content_tag(:div, img, :class=>"logo-#{size}")
  end

  def obj_link klass_or_obj, id=nil
    return "" unless klass_or_obj
    obj = klass_or_obj
    obj = klass_or_obj.where(:id=>id).first if klass_or_obj.is_a?(Class) && id
    if obj
      link_to("#{obj.descriptor} [#{obj.id}]", obj)
    else
      "missing #{klass_or_obj.to_s.humanize.downcase} [#{id}]"
    end
  end

end
