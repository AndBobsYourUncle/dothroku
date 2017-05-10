App.app_deploy = App.cable.subscriptions.create "AppDeployChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#deploy_content').val($("#deploy_content").val() + data);

    scrollTop = $('#deploy_content').scrollTop()
    height = $('#deploy_content').height()
    scrollHeight = $('#deploy_content')[0].scrollHeight

    if (scrollTop + height >= scrollHeight - 100)
      $('#deploy_content').scrollTop(scrollHeight);
