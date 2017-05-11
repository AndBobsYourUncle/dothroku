$(document).on "turbolinks:load", ->
  return unless $(".apps.edit").length > 0

  $('.deploy_link').click (event) ->
    event.preventDefault()

    $('#deploy_content').val('')

    $.get $(@).attr('href')

    $('.update_button').prop 'disabled', true

    $(@).attr "aria-disabled", "true"
    $(@).addClass "disabled"