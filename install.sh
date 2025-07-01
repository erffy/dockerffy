#!/usr/bin/env bash

source ./utils.sh

if [ "$(is_root)" != "true" ]; then
  abort "This script must be run as root."
fi

if [ "$(is_docker_running)" != "true" ]; then
  abort "Docker is not installed or running. Please install and start Docker before proceeding."
fi

mkdir -p /opt/{dockge,stacks}
cp -rf files/core/dockge /opt/dockge

cd /opt/dockge && docker compose up -d
cd $(get_script_dir)

cp -rf files/core/postgresql /opt/stacks
cp -rf files/apps/* /opt/stacks

for path in /opt/stacks/*; do
  info "Running $path"

  cd $path

  if [ -f $path/.env.example ]; then
    mv -f .env.example .env
  fi

  docker compose up -d

  sleep 3
done

cd $(get_script_dir)

success "erffy/dockerfile is successfully installed and running"
