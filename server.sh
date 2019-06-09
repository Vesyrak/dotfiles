#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function check_docker()
{
  validate_command "which docker" "Warning: Docker not found!"
  validate_command "which docker-compose" "Warning: Docker-Compose not found!"
}

function launch_docker_containers()
{
  check_docker
  validate_command "docker-compose -f ./docker/docker-compose.yml up $@" "Error: Something went wrong while launching docker containers"
}

if [[ $@ == "" ]]; then
  launch_docker_containers
else
  launch_docker_containers "-d $@"
fi
