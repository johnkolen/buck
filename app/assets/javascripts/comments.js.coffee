# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('button[data-target="#comment_modal"').on('click', ()->
    id=$(this).parents(".transfer").attr("id").replace("transfer_","")
    $("#comment_modal #comment_transfer_id").val(id)
    modal = $("#comment_modal")
    modal.find('input[type="submit"]').val("Create")
    modal.find('.modal-title').html("Add Comment")
    modal.find('form').attr('action', "/comments")
    modal.find('form').attr('method', "post"))
