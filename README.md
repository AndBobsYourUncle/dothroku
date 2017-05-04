# Initial Setup

* Setup Docker and Docker Compose on host system
* Add SECRET_KEY_BASE and DOCKER_GROUP_ID environment variables to ~/.bashrc

``export DOCKER_GROUP_ID=`getent group docker | cut -d: -f3```
`export SECRET_KEY_BASE=SECRET`

* Run `docker-compose up -d`