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
      broadcast_message "Preparing build container...\n"
      container, image = prepare_container 'docker:dind', [
        'apk add --no-cache git',
        "git clone https://github.com/#{core.app.github_repo} #{core.app.project_name} --depth 1 --branch #{core.app.github_branch}"
      ]
      broadcast_message "Adding in buildpacks...\n"
      container, image = add_buildpacks container, image, core.app
      broadcast_message "Building docker image...\n"
      run_with_output image, ["docker", "build", ".", "-t", core.app.image_name], core.app.project_name

      broadcast_message "Creating network ...\n"
      Docker::Network.create("#{core.app.image_name}_app_network") rescue nil

      broadcast_message "Preparing deploy container...\n"
      container, image = prepare_container 'docker/compose:1.11.2', [
        "version"
      ]
      container, image = add_compose_file container, image, core.app
      broadcast_message "Deploying docker image...\n"
      run_with_output image, ["up", "-d"], core.app.project_name

      core.app.app_services.each do |app_service|
        broadcast_message "Preparing deploy container...\n"
        container, image = prepare_container 'docker/compose:1.11.2', [
          "version"
        ]
        container, image = add_compose_file container, image, app_service
        broadcast_message "Deploying docker image...\n"
        run_with_output image, ["up", "-d"], app_service.project_name
      end

      broadcast_message "Cleaning up images and containers...\n"
      (cleanup_containers + cleanup_images).compact.each do |docker_object|
        docker_object.delete(:force => true) rescue nil
      end

      broadcast_message "Deploy process done.\n"
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

    def get_source_file src, parameters={}
      file = File.read(src)

      parameters.each do |key, value|
        file = file.gsub(key.to_s, value.to_s)
      end

      file
    end

    def add_compose_file container, image, app_object
      container, image = add_file container, image, app_object.compose_filename,
        "/docker-compose.yml", app_object.project_name, app_object.docker_compose_parameters
      [container, image]
    end

    def add_file container, image, src, dest, project_name, parameters={}
      container.store_file("/#{project_name}#{dest}", get_source_file(src, parameters))
      image = container.commit

      cleanup_containers << container
      cleanup_images << image

      [container, image]
    end

    def add_buildpacks container, image, app_object
      app_object.buildpack.files.each do |file|
        broadcast_message "Adding file #{file.destination}\n"
        container, image = add_file container, image, file.full_source,
          file.destination, app_object.project_name, app_object.docker_compose_parameters
      end

      [container, image]
    end

    def run_with_output image, cmd, project_name
      container = Docker::Container.create(
        "Image" => image.id,
        "WorkingDir" => "/#{project_name}",
        "HostConfig" => {
          "Binds" => ["/var/run/docker.sock:/var/run/docker.sock"]
        },
        "Cmd" => cmd
      )
      container.start

      cleanup_containers << container

      broadcast_container_output container
    end

    def broadcast_message message
      ActionCable.server.broadcast "deploy_channel-#{core.app.image_name}", message
    end

    def broadcast_container_output container
      begin
        container.attach(ATTACH_DEFAULTS.dup) do |stream, chunk|
          output = stream_to_output stream, chunk

          broadcast_message output.to_s.strip_extended
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
