class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def run_with_output image, cmd
    container = Docker::Container.create('Image' => image.id, "WorkingDir" => "/bootstrap", 'HostConfig' => {"Binds" => ["/var/run/docker.sock:/var/run/docker.sock"]}, "Cmd" => cmd)
    container.tap(&:start).attach(stream: true, stdout: true, stderr: true, logs: true) do |stream, chunk|
      output = chunk.present? ? "#{stream}: #{chunk}" : stream
      output ||= stream

      ActionCable.server.broadcast 'deploy_channel', output.to_s.strip_control_and_extended_characters
    end

  end

  def perform(app)
    image = Docker::Image.create('fromImage' => 'docker:dind')
    container = image.run('apk add --no-cache git')
    container.attach(stream: true, stdout: true, stderr: true, logs: true) do |stream, chunk|
      output = chunk.present? ? "#{stream}: #{chunk}" : stream
      output ||= stream

      ActionCable.server.broadcast 'deploy_channel', output.to_s.strip_control_and_extended_characters
    end
    image = container.commit

    container = image.run('git clone --depth 1 https://github.com/judetucker/bootstrap')
    container.attach(stream: true, stdout: true, stderr: true, logs: true) do |stream, chunk|
      output = chunk.present? ? "#{stream}: #{chunk}" : stream
      output ||= stream

      ActionCable.server.broadcast 'deploy_channel', output.to_s.strip_control_and_extended_characters
    end
    container.store_file("/bootstrap/Dockerfile", File.read('buildpacks/Dockerfile'))
    image = container.commit

    run_with_output image, ["docker", "build", "."]

    # image.delete(:force => true)
  end
end
