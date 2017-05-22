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
# Load required modules
module logs

# ----------------------------------------------------------
# Test if docker daemon is responding
# @usage
# 	if check_docker_daemon; then
#		do_something
# 	fi
# @param 	-
# @variable -
function check_docker_daemon() {
	if [[ "x$(which docker)" == "x" ]]; then
		warning "Missing docker binary"
		return 1
	fi

	docker info > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		warning "Unable to talk to the docker daemon"
		return 1
	fi
}

# ----------------------------------------------------------
# Test if a container is created
# @usage
#   if is_container_created foobar; then
#       do something
#   fi
#
# @param    Container name
# @variable -
function is_container_created() {
	local CONTAINER=$1
	if ! check_docker_daemon; then
		error "A working docker daemon is required. Exiting"
		exit 1
	fi
	docker inspect ${CONTAINER} &> /dev/null
	return $?
}

# ----------------------------------------------------------
# Test if a container is running
# Usage :
#   if is_container_running foobar; then
#       # do something
#   fi
#
# @param    Container name
# @variable -
function is_container_running() {
	local CONTAINER=$1

	if ! check_docker_daemon; then
		error "A working docker daemon is required. Exiting"
		exit 1
	fi

	RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)
	if [ $? -ne 0 ]; then
		# container not found, not created or error during Inspect
		return 1
	fi
	if [[ "$RUNNING" == "false" ]]; then
		return 1
	fi
	return 0
}

# ----------------------------------------------------------
# Return container's status
# Usage :
#   local STATUS=$(get_container_status foobar)
#
# @param    Container name
# @variable -
function get_container_status() {
	local CONTAINER=$1
	docker inspect -f '{{ .State.Status }}' ${CONTAINER}
}

# ----------------------------------------------------------
# Return container's stats
# Usage :
#   local STATS=$(get_container_stats foobar)
#
# @param    Container name
# @variable -
function get_container_stats()
{
	local CONTAINER=$1
    docker stats --no-stream ${CONTAINER}
}

# ----------------------------------------------------------
# Start a container
# Usage :
#   start_container foobar)
#
# @param    Container name
# @variable -
function start_container()
{
    local CONTAINER=$1
    if ! is_container_created ${CONTAINER} ; then
    	error "Container '${CONTAINER}' does not exist, unable to start"
    	return 1
    fi

    if ! is_container_running ${CONTAINER} ; then
    	docker start ${CONTAINER} &> /dev/null
    	return $?
    fi
    return 0
}

# ----------------------------------------------------------
# Stop a container
# Usage :
#   stop_container foobar)
#
# @param    Container name
# @variable -
function stop_container()
{
    local CONTAINER=$1
    if ! is_container_created ${CONTAINER} ; then
    	error "Container '${CONTAINER}' does not exist, unable to stop"
    	return 1
    fi

    if is_container_running ${CONTAINER} ; then
    	docker stop ${CONTAINER} &> /dev/null
    	return $?
    fi
    return 0
}

# ----------------------------------------------------------
# Display container status
# Usage :
#   container_status Container_Name
#
# @param    Container name
# @variable -
function container_status() {
	local CONTAINER=$1

	if ! check_docker_daemon; then
		error "A working docker daemon is required. Exiting"
		exit 1
	fi

	if is_container_created ${CONTAINER}; then
		if is_container_running ${CONTAINER}; then
			info "Container ${BLUE_B}${CONTAINER}${NC} is ${GREEN_B}created${NC} and ${GREEN_B}running${NC}"
		else
			info "Container ${BLUE_B}${CONTAINER}${NC} is ${GREEN_B}created${NC} and ${RED_B}NOT running${NC}"
		fi
	else
		info "Container ${BLUE_B}${CONTAINER}${NC} is ${RED_B}NOT created${NC}"
	fi
}
