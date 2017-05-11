$(document).on "turbolinks:request-start", ->
  return unless $(".apps.edit").length > 0

  console.log 'Unubscribed to app status channel'

  App.app_status.unsubscribe()


$(document).on "turbolinks:load", ->
  return unless $(".apps.edit").length > 0

  console.log 'Subscribed to app status channel'
  App.app_status = App.cable.subscriptions.create {channel: "AppStatusChannel", "image_name": $("#app_image_name").val()},
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      if data.deploying && data.deploying[1]
        $('.app_status_button').removeClass 'btn-success'
        $('.app_status_button').addClass 'btn-warning'

        $('.app_status_button i').removeClass 'fa-check-circle'
        $('.app_status_button i').addClass 'fa-clock-o'

        $('.app_status_button .btn-text').text 'Deploying'

      else if data.deploying && !data.deploying[1]
        $('.update_button').prop 'disabled', false
        $('.deploy_link').attr "aria-disabled", "false"
        $('.deploy_link').removeClass "disabled"

        $('.app_status_button').addClass 'btn-success'
        $('.app_status_button').removeClass 'btn-warning'

        $('.app_status_button i').addClass 'fa-check-circle'
        $('.app_status_button i').removeClass 'fa-clock-o'

        $('.app_status_button .btn-text').text 'Deployed'

