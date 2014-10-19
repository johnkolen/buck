$ ->
  $("#friend_cb_form #cb").on "click", ()->
    tgt = $("#friend_cb_form")
    if $(this).prop("checked")
      tgt.attr("action","/friends/add")
    else
      tgt.attr("action","/friends/remove")
    tgt.submit()
