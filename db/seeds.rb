Buildpack.create(
  name: 'jekyll',
  files_attributes: [
    {source: "/Dockerfile", destination: "/Dockerfile"}
  ]
)