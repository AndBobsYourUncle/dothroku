require 'docker_deploy/container'

module DockerDeploy
  class Core
    attr_accessor :app

    def initialize(options={})
      options.each {|key, value| send("#{key}=", value)}
    end

    def deploy
      container = DockerDeploy::Container.new()

      @app.update(deploying: false)
    end
  end
end