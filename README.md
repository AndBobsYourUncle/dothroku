# Initial Setup

* Setup Docker and Docker Compose on host system

`docker network create dothroku_nginx`

* Add SECRET_KEY_BASE and DOCKER_GROUP_ID environment variables to ~/.bashrc

``
export DOCKER_GROUP_ID=`getent group docker | cut -d: -f3`
``

`export SECRET_KEY_BASE=SECRET`

* Add Github app client ID and secret to ~/.bashrc

``
export GITHUB_CLIENT_ID=[CLIENT_ID]
export GITHUB_CLIENT_SECRET=[CLIENT_SECRET]
``

* Run `docker-compose up -d`

* If the initial Postgres DB did not initialize in time for the Dothroku container run:

`docker-compose restart`

* To initially seed the database run:

`docker exec dothroku bash -c "RAILS_ENV=production rails db:seed"`
