module ApplicationHelper
  def logo size
    content_tag(:div, "Bet U a Buck", :class=>size)
  end
end
