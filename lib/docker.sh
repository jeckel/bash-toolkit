#!/usr/bin/env bash

# ======================================================================================================================
# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT
#
# Docker management functions

if ! declare -f module &>/dev/null; then
	echo "This file should not be loaded directly, load 'main.sh' and the use the 'module' function"
fi


# ----------------------------------------------------------
# Test if docker daemon is working
# Usage :
#   if is_docker_working; then
#       # do something
#   fi
function is_docker_working
{
  if [ "x$(which docker)" == "x" ]; then
    echo "UNKNOWN - Missing docker binary"
    exit 3
  fi

  docker info > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "UNKNOWN - Unable to talk to the docker daemon"
    exit 3
  fi
}

# ----------------------------------------------------------
# Test if a container is created
# Usage :
#   if is_container_created foobar; then
#       # do something
#   fi
#
# Params:
#   $1 : Container name
function is_container_created() {
  local CONTAINER=$1
  docker inspect $CONTAINER &> /dev/null
  return $?
}

# ----------------------------------------------------------
# Test if a container is running
# Usage :
#   if is_container_running foobar; then
#       # do something
#   fi
#
# Params:
#   $1 : Container name
function is_container_running() {
  local CONTAINER=$1
  RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)
  if [ $? -ne 0 ]; then
    # container not found, not created or error during Inspect
    return 1
  fi
  if [ "$RUNNING" == "false" ]; then
    return 1
  fi
  return 0
}
