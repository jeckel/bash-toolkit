#!/usr/bin/env bash

# Load framework
readonly BIN="$(dirname "$0")"
source ${BIN}/../main.sh

# Load required modules
module docker


DEFAULT_SERVICE="portainer"
SERVICE=$DEFAULT_SERVICE
COMMAND="status"


####################
# Show help message
####################

function show_help()
{
cat << EOF
Usage: ${0##*/} [-h] [-s CONTAINER] [COMMAND]
    -h           Show this help
    -s CONTAINER Define container to monitor (default : $DEFAULT_SERVICE)

Command :
  - status  : Test if service is running and display status
  - start   : Start container
  - stop    : Stop container
  - restart : Restart container
EOF
}

###################
# Parse args and options
###################
function parseArgs()
{
    while getopts "hs:" opt; do
        case "$opt" in
            h)
                show_help
                exit 0
                ;;
            s)
                SERVICE=$OPTARG
                ;;
            '?')
                show_help
                exit 1
                ;;
        esac
    done

    if [ ! -z ${@:$OPTIND} ] ; then
        COMMAND=${@:$OPTIND}
    fi
}

function status_action()
{
	local CONTAINER=$1
	if ! is_container_created ${CONTAINER} ; then
		error "Service ${CONTAINER} not created"
		return 1
	fi

	if ! is_container_running ${CONTAINER} ; then
		local STATUS=$(get_container_status ${CONTAINER})
		error "Service ${CONTAINER} is not running, status : ${STATUS}"
		return 1
	fi

	info "Service '${CONTAINER}' is 'running'"
	get_container_stats ${CONTAINER}
	return 0
}

parseArgs "$@"

case "$COMMAND" in
    start)
        start_container ${SERVICE}
        exit $?
        ;;
    status)
        status_action ${SERVICE}
        exit $?
        ;;
    stop)
        stop_container ${SERVICE}
        exit $?
        ;;
    restart)
        if stop_container ${SERVICE} ; then
        	start_container ${SERVICE}
        	exit $?
        else
        	exit 1
        fi
        ;;
    *)
        show_help
        exit 1
        ;;
esac
