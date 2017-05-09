class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def perform(app)

    container = Docker::Container.create('Image' => 'ubuntu', 'Cmd' => ['bash', '-c', 'apt-get update'])
    container.tap(&:start).attach { |stream, chunk| puts "#{stream}: #{chunk}" }
    image = container.commit

    container = Docker::Container.create('Image' => image.id, 'Cmd' => ['bash', '-c', 'apt-get install git -y'])
    container.tap(&:start).attach { |stream, chunk| puts "#{stream}: #{chunk}" }
    image = container.commit

  end
end
