#!/usr/bin/env bash

# Load framework
readonly BIN="$(dirname "$0")"
source ${BIN}/../main.sh

# Load required modules
module docker

# ----------------------------------------------------------
# Display Usage info
#
function show_help() {
cat << EOF
Usage: ${0##*/} [-h] container
Monitor container status
    -h      Display this help and exit
EOF
}

# ----------------------------------------------------------
# Parse command line option to redefine parameters
#
while getopts "h" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))


# Check docker daemon
if ! check_docker_daemon; then
	error "Docker seems not properly installed. Exiting"
fi

declare -r CONTAINER_NAME=${1:-FooBar}

container_status ${CONTAINER_NAME}
