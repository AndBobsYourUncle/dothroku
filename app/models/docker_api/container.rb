class DockerAPI::Container
  extend ActiveModel::Naming
  attr_accessor :id, :name, :image, :state, :status

  def initialize(opts={})
    opts.each do |key, val|
      public_send "#{key}=", val
    end
  end
  def self.all
    Docker::Container.all(all: true).map do |container|
      new(
        id: container.id,
        name: container.info["Names"].map { |name| name[1..-1] }.join(', '),
        image: container.info["Image"],
        state: container.info["State"],
        status: container.info["Status"]
      )
    end
  end
  def self.find(param)
    Docker::Container.get(param)
  end

  def to_model
  end

  def persisted?
    false
  end
end