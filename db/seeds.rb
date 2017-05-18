Buildpack.create(
  name: 'jekyll',
  files_attributes: [
    {source: "/Dockerfile", destination: "/Dockerfile"}
  ]
)

Buildpack.create(
  name: 'passenger_rails',
  files_attributes: [
    {source: "/Dockerfile", destination: "/Dockerfile"},
    {source: "/script/docker/rails-init", destination: "/script/docker/rails-init"},
    {source: "/nginx.conf", destination: "/nginx.conf"},
    {source: "/docker-env.conf", destination: "/docker-env.conf", env_file: true, env_template: "env %<name>s;\n"}
  ]
)


Service.create(
  name: 'redis',
  service_variables_attributes: [
    {
      name: 'REDIS_URL',
      value: 'redis://%<image_name>s:6379',
      build_type: :interpolate,
      service_variable_sources_attributes: [
        {name: 'image_name', source_model: :app_service, source_attribute: :image_name}
      ]
    }
  ]
)