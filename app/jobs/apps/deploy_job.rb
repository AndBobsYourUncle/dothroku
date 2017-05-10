require 'docker_deploy/docker_deploy'

class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def perform(app)
    DockerDeploy.new(app: app).deploy
  end
end
