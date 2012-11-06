$(document).ready ->

  $("#clients_select").change ->
    $.ajax
      url: $("#clients_select").data('url')
      data:
        client_id: $("#clients_select").val()
      dataType: "script"

  $(".submitter").each (i, element) =>
    $(element).change ->
      @form.submit()