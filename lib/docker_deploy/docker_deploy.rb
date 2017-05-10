class DockerDeploy
  ATTACH_DEFAULTS = {stream: true, stdout: true, stderr: true, logs: true}.freeze

  attr_accessor :app

  def initialize(options={})
    options.each {|key, value| send("#{key}=", value)}
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

  def broadcast_container_output container
    container.attach(ATTACH_DEFAULTS.dup) do |stream, chunk|
      output = stream_to_output stream, chunk

      ActionCable.server.broadcast 'deploy_channel', output.to_s.strip_extended
    end
  end

  def run_with_output image, cmd
    container = Docker::Container.create(
      "Image" => image.id,
      "WorkingDir" => "/bootstrap",
      "HostConfig" => {
        "Binds" => ["/var/run/docker.sock:/var/run/docker.sock"]
      },
      "Cmd" => cmd
    )
    container.start

    broadcast_container_output container
  end

  def run_image_command(cmd, image_name: nil, image: nil)
    image = Docker::Image.create('fromImage' => image_name) if image_name
    container = image.run(cmd)
    broadcast_container_output container

    image = container.commit
    [container, image]
  end

  def prepare_container
    container, image = [nil, nil]
    [
      'apk add --no-cache git',
      'git clone --depth 1 https://github.com/judetucker/bootstrap',
      'ls'
    ].each do |cmd|
      if image
        container, image = run_image_command cmd, image: image
      else
        container, image = run_image_command cmd, image_name: 'docker:dind'
      end
    end
    [container, image]
  end

  def add_buildpacks container, image
    dockerfile_path = 'buildpacks/Dockerfile'
    container.store_file("/bootstrap/Dockerfile", File.read(dockerfile_path))
    image = container.commit

    [container, image]
  end

  def deploy
    container, image = prepare_container

    container, image = add_buildpacks container, image

    run_with_output image, ["docker", "build", "."]

    @app.update(deploying: false)
  end
end