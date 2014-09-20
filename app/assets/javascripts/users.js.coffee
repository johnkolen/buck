# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.btn-file :file').on('change', ()->
    tgt = $(this)
    files = tgt.get(0).files
    numFiles = if files then files.length else 1
    label = tgt.val().replace(/\\/g, '/').replace(/.*\//, '')
    tgt.parent().find('.msg').html('Uploading')
    tgt.parent().find('.filename').html(' '+label))
