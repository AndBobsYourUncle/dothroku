App.app_deploy = App.cable.subscriptions.create "AppDeployChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # console.log data
    $('#deploy_content').val($("#deploy_content").val() + data);
    $('#deploy_content').scrollTop($('#deploy_content')[0].scrollHeight);
    # Called when there's incoming data on the websocket for this channel
