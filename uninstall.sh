#!/usr/bin/env bash

source ./utils.sh

if [ "$(is_root)" != "true" ]; then
  abort "This script must be run as root."
fi

if [ "$(is_docker_running)" != "true" ]; then
  abort "Docker is not installed or running. Please install and start Docker before proceeding."
fi

containers=($(docker ps -aq))
for container in "${containers[@]}"; do
  info "Container $container is removing"
  docker container stop $container >/dev/null && docker container rm $container >/dev/null
done

sleep 3

rm -rf /opt/{dockge,stacks,containerd}

success "erffy/dockerfile is successfully stopped and removed"
