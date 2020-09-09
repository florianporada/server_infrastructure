logthis() {
  now=$(date +"%T")
  log_name=CLEANUP_DOCKER_ENV
  echo "$log_name ($now): $1"
}

# logthis 'Listing disk usage'
# du -h / | grep '[0-9\,]\+G'

logthis "Remove all unused images"
docker_images=$(docker image ls -aq --filter "dangling=true")

if [ -z "$docker_images" ]; then
  logthis "No images to clean"
else
  docker rmi $docker_images
fi

logthis 'Remove all unused containers'
docker_container=$(docker container ls --filter "status=exited" -aq)

if [ -z "$docker_container" ]; then
  logthis "No container to clean"
else
  docker container rm $docker_container
fi
