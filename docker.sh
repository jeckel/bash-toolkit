#!/usr/bin/env bash

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