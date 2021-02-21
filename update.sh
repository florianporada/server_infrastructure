#!/bin/bash

# exit when any command fails
set -e

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq:3.3.4 yq "$@"
}

logthis() {
  now=$(date +"%T")
  log_name=UPDATE_DOCKER_ENV
  echo "$log_name ($now): $1"
}

die() { logthis "$*" 1>&2 ; exit 1; }

# Usage info
show_help() {
cat << EOF
Searches the docker-compose file for the sercvice name and updates the image accordingly

    -h          display this help and exit
    -i          Docker image name (e.g foo/bar:latest)
    -n          Service name
    -f FILE     docker-compose.yaml to update

EOF
}

check_args() {
if [ -z ${file+x} ]; then
  file='./docker-compose.yaml'
fi

if [ -z ${name+x} ]; then
  die 'ERROR: "-n --name is mandatory"'
fi

if [ -z ${image+x} ]; then
  die 'ERROR: "-i --image is mandatory"'
fi
}

run() {
  logthis "Update service: '$name' with image: '$image'"
  yq w -i ${file} services[${name}].image ${image}

  docker-compose pull ${name}
  docker-compose up -d --force-recreate ${name}
}

while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        -i|--image)
            if [ "$2" ]; then
                image=$2
                shift
            else
                die 'ERROR: "-i --image" requires a non-empty option argument.'
            fi
            ;;
        -n|--name)
            if [ "$2" ]; then
                name=$2
                shift
            else
                die 'ERROR: "-n --name" requires a non-empty option argument.'
            fi
            ;;
        -f|--file)
            if [ "$2" ]; then
                file=$2
                shift
            fi
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac

    shift
done


logthis "Enter infrastructure directory"
cd /www/docker/server_infrastructure/

check_args
run

./cleanup.sh
