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
    {source: "/docker-env.conf", destination: "/docker-env.conf"}
  ]
)


Service.create(
  name: 'redis'
)