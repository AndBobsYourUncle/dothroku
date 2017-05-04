class DockerApi::Container
  include ActiveModel::Validations
  include ActiveModel::Conversion
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
    container = Docker::Container.get(param)

    new(
      id: container.id,
      name: container.info["Name"][1..-1],
      image: container.info["Config"]["Image"],
      state: container.info["State"]["Status"],
      status: (container.info["State"]["FinishedAt"].to_datetime - container.info["State"]["StartedAt"].to_datetime)
    )
  end

  def stop
    container = Docker::Container.get(id)
    container.stop
  end

  def start
    container = Docker::Container.get(id)
    container.start
  end

  def to_param
    id[0..11]
  end

  def to_model
  end

  def persisted?
    false
  end
end