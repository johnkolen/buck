# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.transfer_list_update_interval = 30000

window.update_transfer_list = (transfer)->
  id = transfer.attr("id")
  tgt = $("#" + id)
  if tgt.size() > 0
    tgt.remove()
  $("#transfer_list").prepend(transfer.hide())
  $("#" + id).fadeIn(1000)


