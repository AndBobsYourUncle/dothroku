module DockerDeploy
  class Container
    ATTACH_DEFAULTS = {stream: true, stdout: true, stderr: true, logs: true}.freeze

    attr_accessor :core, :cleanup_containers, :cleanup_images

    def initialize(options={})
      options.each {|key, value| send("#{key}=", value)}
      self.cleanup_containers = []
      self.cleanup_images = []
    end

    def deploy
      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Preparing build container...\n"
      container, image = prepare_container 'docker:dind', [
        'apk add --no-cache git',
        "git clone https://github.com/#{core.app.github_repo} --depth 1 --branch #{core.app.github_branch}"
      ]
      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Adding in buildpacks...\n"
      container, image = add_buildpacks container, image
      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Building docker image...\n"
      run_with_output image, ["docker", "build", ".", "-t", core.app.image_name]

      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Preparing deploy container...\n"
      container, image = prepare_container 'docker/compose:1.8.0', [
        "version"
      ]
      container, image = add_file container, image, core.app.buildpack.compose_filename, "/docker-compose.yml", true
      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Deploying docker image...\n"
      run_with_output image, ["up", "-d"]

      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Cleaning up images and containers...\n"
      (cleanup_containers + cleanup_images).compact.each do |docker_object|
        docker_object.delete(:force => true) rescue nil
      end

      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Deploy process done.\n"
    end

    def prepare_container image_name, commands
      container, image = [nil, nil]
      commands.each do |cmd|
        if image
          container, image = run_image_command cmd, image: image
        else
          container, image = run_image_command cmd, image_name: image_name
        end
      end
      [container, image]
    end

    def run_image_command(cmd, image_name: nil, image: nil)
      image = Docker::Image.create('fromImage' => image_name) if image_name

      cleanup_images << image

      container = image.run(cmd)

      cleanup_containers << container

      broadcast_container_output container

      image = container.commit

      cleanup_images << image

      [container, image]
    end

    def get_source_file src, deploy
      if deploy
        file = File.read(src)
        file = file.gsub('DOTHROKU_IMAGE_NAME', core.app.image_name)
        file = file.gsub('DOTHROKU_CONTAINER_NAME', core.app.image_name)
        file = file.gsub('DOTHROKU_HOSTNAME', core.app.hostname)
        file = file.gsub('DOTHROKU_EMAIL', core.app.ssl_email)
        file
      else
        File.read(src)
      end
    end

    def add_file container, image, src, dest, deploy=false
      container.store_file("/#{core.app.github_repo.split('/')[1]}#{dest}", get_source_file(src, deploy))
      image = container.commit

      cleanup_containers << container
      cleanup_images << image

      [container, image]
    end

    def add_buildpacks container, image
      core.app.buildpack.files.each do |file|
        ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", "Adding file #{file.destination}\n"
        container, image = add_file container, image, file.full_source, file.destination
      end

      [container, image]
    end

    def run_with_output image, cmd
      container = Docker::Container.create(
        "Image" => image.id,
        "WorkingDir" => "/#{core.app.github_repo.split('/')[1]}",
        "HostConfig" => {
          "Binds" => ["/var/run/docker.sock:/var/run/docker.sock"]
        },
        "Cmd" => cmd
      )
      container.start

      cleanup_containers << container

      broadcast_container_output container
    end

    def broadcast_container_output container
      begin
        container.attach(ATTACH_DEFAULTS.dup) do |stream, chunk|
          output = stream_to_output stream, chunk

          ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", output.to_s.strip_extended
        end
      rescue Docker::Error::TimeoutError => e
        broadcast_container_output container
      end
    end

    def stream_to_output stream, chunk
      if chunk.present? && stream.to_s == 'stdout'
        chunk
      elsif chunk.present?
        "#{stream}: #{chunk}"
      else
        stream
      end
    end

  end
end
