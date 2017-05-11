#!/usr/bin/env bash

# ----------------------------------------------------------
# Define constants

# Current script directory
readonly BIN="$(dirname "$0")"

# Git project root (uncomment if in a git project)
#readonly PROJECT_PATH=$(git rev-parse --show-toplevel)

# ----------------------------------------------------------
# Define default values
readonly DFL_FILE=$0


# ----------------------------------------------------------
# Import common functions
#
source ../main.sh


# ----------------------------------------------------------
# Display Usage info
#
function show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-f FILE] command
Launch batch
    -f FILE File to process (default: "$DFL_FILE")
    -h      Display this help and exit
EOF
}

# ----------------------------------------------------------
# Initialize with default values
FILE=$DFL_FILE

# ----------------------------------------------------------
# Parse command line option to redefine parameters
#
while getopts "f:hk" opt; do
    case "$opt" in
        f)
            FILE=$OPTARG
            ;;
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

# ----------------------------------------------------------
# Launch script
#
cat $FILE $@
RESULT=$?


exit "$RESULT"