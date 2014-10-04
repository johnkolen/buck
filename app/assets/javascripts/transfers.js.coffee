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

window.transfer_messages =
 ["Send Money", "Request Money", "Send Bet", "Send Pledge"]

$ ->
  $(".new_transfer #transfer_kind").on("change", (event)->
    msg = window.transfer_messages[$(this).val()]
    $(".new_transfer input[type=submit]").val(msg))

