module DockerDeploy
  class Core
    attr_accessor :app

    def initialize(options={})
      options.each {|key, value| send("#{key}=", value)}
    end

    def deploy
      @app.update(deploying: true)

      container = DockerDeploy::Container.new(core: self)
      container.deploy

      @app.update(deploying: false)
    end
  end
end
