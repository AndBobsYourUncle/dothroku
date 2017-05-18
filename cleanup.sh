docker rm $(docker ps -a -f status=exited -f status=created -q)
docker rmi $(docker images -a -q)
