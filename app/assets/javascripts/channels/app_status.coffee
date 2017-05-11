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
      console.log data

      if data == 'not deploying'
        $('.update_button').prop 'disabled', false

        $('.deploy_link').attr "aria-disabled", "false"
        $('.deploy_link').removeClass "disabled"
