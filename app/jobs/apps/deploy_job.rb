require 'docker_deploy/core'

class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def perform(app)
    ActionCable.server.broadcast "app_status_channel-#{app.image_name}", 'deploying'

    DockerDeploy::Core.new(app: app).deploy

    ActionCable.server.broadcast "app_status_channel-#{app.image_name}", 'not deploying'
  end
end
