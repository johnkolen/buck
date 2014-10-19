# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('form[data-remote="true"]').on('submit', (e)->
    if $(this).data("other_submit")
      $(this).data("other_submit").type = $(this).attr("method").toUpperCase()
      $(this).data("other_submit").url = $(this).attr("action") + ".js"
      e.preventDefault();
      $(this).data("other_submit").submit()
      return false)
  $('form[data-remote="true"] input[type="file"]').fileupload
    dataType: 'script'
    add: (e,data) ->
      types = /(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        tgt = $(e.target)
        files = tgt.get(0).files
        numFiles = if files then files.length else 1
        label = file.name.replace(/\\/g, '/').replace(/.*\//, '')
        tgt.parent().find('.msg').html('Uploading')
        tgt.parent().find('.filename').html(' '+label)
        f = $(tgt.parents('form')[0])
        f.data('other_submit', data)
      else
        alert("#{file.name} is not a gif, jpg or png image file")
  $('.btn-file input[type=file]').on('change', ()->
    tgt = $(this)
    files = tgt.get(0).files
    numFiles = if files then files.length else 1
    label = tgt.val().replace(/\\/g, '/').replace(/.*\//, '')
    tgt.parent().find('.msg').html('Uploading')
    tgt.parent().find('.filename').html(' '+label))
  $("#password_form > a").on("click", ()->
    tgt = $(this)
    if tgt.html() == "Change Password"
      tgt.html("Close Change Password")
    else
      $("#password_form .well").remove()
      tgt.html("Change Password"))
  $("#find-profile").on("submit", ()->
    tgt = $(this)
    id = tgt.find("#id").val()
    tgt.attr('action',tgt.attr('action').replace("#",id)))