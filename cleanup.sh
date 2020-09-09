logthis() {
  now=$(date +"%T")
  log_name=CLEANUP_DOCKER_ENV
  echo "$log_name ($now): $1"
}

# logthis 'Listing disk usage'
# du -h / | grep '[0-9\,]\+G'

logthis 'Remove all unused images'
docker rmi $(docker image ls -aq --filter "dangling=true")

logthis 'Remove all unused containers'
docker container rm $(docker container ls --filter "status=exited" -aq)

