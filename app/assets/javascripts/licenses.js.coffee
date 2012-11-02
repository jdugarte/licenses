# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#clients_select").change ->
    $.ajax
      url: $("#clients_select").data('url')
      data:
        client_id: $("#clients_select").val()
      dataType: "script"