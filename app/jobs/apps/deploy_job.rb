class Apps::DeployJob < ApplicationJob
  queue_as :deploy

  def perform(app)

    container = Docker::Container.create('Image' => 'ubuntu', 'Cmd' => ['bash', '-c', 'apt-get update'])
    container.tap(&:start).attach do |stream, chunk|
      puts "#{stream}: #{chunk}"
      ActionCable.server.broadcast 'deploy_channel', chunk
    end
    image = container.commit
    container.delete(:force => true)

    container = Docker::Container.create('Image' => image.id, 'Cmd' => ['bash', '-c', 'apt-get install git -y'])
    container.tap(&:start).attach do |stream, chunk|
      puts "#{stream}: #{chunk}"
      ActionCable.server.broadcast 'deploy_channel', chunk
    end
    image2 = container.commit
    container.delete(:force => true)

    image.delete(:force => true)
    image2.delete(:force => true)
  end
end
