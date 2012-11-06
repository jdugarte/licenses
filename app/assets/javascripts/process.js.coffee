$(document).ready ->
  $("#select_all").change -> SelectAll()
      
SelectAll = () ->
  selection = $("#select_all").is(':checked')
  $(".select_license").each (i, element) =>
    $(element).attr('checked', selection)