$(document).ready ->
  $('.ajax_link').click (event) ->
    event.preventDefault()

    $.get $(@).attr('href'), (response) ->
      console.log response