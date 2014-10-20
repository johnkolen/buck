$ ->
  $("#friend_cb_form #cb").on "click", ()->
    tgt = $("#friend_cb_form")
    if $(this).prop("checked")
      tgt.attr("action","/friends/add")
    else
      tgt.attr("action","/friends/remove")
    tgt.submit()
  $(".send-bucks-button").on "click", ()->
    tgt = $(this)
    id = tgt.attr("data-id")
    name = tgt.attr("data-name")
    $("#new_transfer #transfer_recipient_id").val(id)
    $("#new_transfer p.form-control-static").html(name)
    $("#send_modal").modal("show")

