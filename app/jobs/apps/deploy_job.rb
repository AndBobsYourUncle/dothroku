require 'docker_deploy/core'

class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def perform(app)
    DockerDeploy::Core.new(app: app).deploy
  end
end
