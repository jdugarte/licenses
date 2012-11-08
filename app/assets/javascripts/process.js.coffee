do_on_load = ->
  $("#select_all").change -> SelectAll()
      
SelectAll = () ->
  selection = $("#select_all").is(':checked')
  $(".select_license").each (i, element) =>
    $(element).attr('checked', selection)


$(document).ready(do_on_load)
$(document).on("page:change", do_on_load)