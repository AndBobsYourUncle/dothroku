$(document).ready ->
  $('.ajax_link').click (event) ->
    event.preventDefault()

    $('#deploy_content').val('')

    $.get $(@).attr('href'), (response) ->
      console.log response