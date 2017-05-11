#!/usr/bin/env bash

# ======================================================================================================================
# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT
#
# Log management functions

if ! declare -f module &>/dev/null; then
	echo "This file should not be loaded directly, load 'main.sh' and the use the 'module' function"
fi

# ----------------------------------------------------------
# Load required modules
module colors

# ----------------------------------------------------------
# Constants
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARNING=2
readonly LOG_ERROR=3
readonly LOG_PREFIX=("${BOLD}DBG${NC}" "${BLUE_B}INF${NC}" "${ORANGE_B}WRN${NC}" "${RED_B}ERR${NC}")
readonly LOG_PAGE_WITH=80
readonly LOG_PADDING=15

# ----------------------------------------------------------
# Global Variables
LOG_LEVEL="$LOG_INFO"
LOG_STEP=false
LOG_STEP_LEVEL="$LOG_INFO"


# ----------------------------------------------------------
# Log a message
#
# Params:
#   $1 : Message
#   $2 : Level (default: info)
function log_message() {
    local MESSAGE=$1
    local LEVEL=${2:-$LOG_INFO}
    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
        if "$LOG_STEP" ; then
            printf "\n"
            LOG_STEP=false
        fi
        printf "[${LOG_PREFIX[$LEVEL]}] $MESSAGE${NC}\n"
    fi
}


# ----------------------------------------------------------
# Log an error message
#
# Params:
#   $1 : Message
function error() {
    log_message "$1" "$LOG_ERROR"
}


# ----------------------------------------------------------
# Log a warning message
#
# Params:
#   $1 : Message
function warning() {
    log_message "$1" "$LOG_WARNING"
}


# ----------------------------------------------------------
# Log a info message
#
# Params:
#   $1 : Message
function info() {
    log_message "$1" "$LOG_INFO"
}

# ----------------------------------------------------------
# Log a debug message
#
# Params:
#   $1 : Message
function debug() {
    log_message "$1" "$LOG_DEBUG"
}


# ----------------------------------------------------------
# Start a stepped log message (message which will be updated at each step of action)
#
# Params:
#   $1 : Message
#   $2 : Level (default: Info)
function start_stepped_log()
{
    local MESSAGE=$1
    local LEVEL=${2:-$LOG_INFO}
    LOG_STEP=true
    LOG_STEP_LEVEL="$LEVEL"

    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
        printf "[${LOG_PREFIX[$LEVEL]}] $MESSAGE${NC}"
        printf "\033[s" # save cursor position
    fi
}


# ----------------------------------------------------------
# Add/Update stepp to a stepped message
#
# Params:
#   $1 : Message
function add_stepped_log()
{
    local MESSAGE=$1
    local LEVEL="$LOG_STEP_LEVEL"
    if ! "$LOG_STEP" ; then
        # Log step not started
        log_message "$MESSAGE" "$LEVEL"
        return
    fi
    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
        printf "\033[u\033[K"
        printf "$MESSAGE${NC}"
    fi
}


# ----------------------------------------------------------
# End stepped message with a final message
#
# Params:
#   $1 : Message
function end_stepped_log()
{
    local MESSAGE=$1
    add_stepped_log "$MESSAGE"
    printf "\n"
    LOG_STEP=false
}


# ----------------------------------------------------------
# Display a fancy header for a debug block
#
# Params:
#   $1 : Header text
#   $2 : Color (Default: orange bold)
#   $3 : Level (Default: Info)
function log_var_header()
{
    local HEADER=$1
    local COLOR=${2:-$ORANGE_B}
    local LEVEL=${3:-$LOG_INFO}
    local COL_LEFT=0
    local COL_RIGHT=0

    if [ "$LEVEL" -ge "$LOG_LEVEL" ]
    then
        if "$LOG_STEP"
        then
            printf "\n"
            LOG_STEP=false
        fi

        rem=$(( ${#HEADER} % 2 ))
        if [ $rem -eq 0 ]
        then
            let COL_LEFT=(${LOG_PAGE_WITH}-${#HEADER})/2-1
            COL_RIGHT="$COL_LEFT"
        else
            let COL_LEFT=(${LOG_PAGE_WITH}-${#HEADER})/2
            let COL_RIGHT=${COL_LEFT}-1
        fi
        printf "[${LOG_PREFIX[$LEVEL]}] "
        printf '=%.0s' $(eval "echo {1.."$(($COL_LEFT))"}");
        printf "[${COLOR}$HEADER${NC}]"
        printf "=%.0s" $(eval "echo {1.."$(($COL_RIGHT))"}");
        printf "\n"
    fi
}

# ----------------------------------------------------------
# Log a variable result in fancy columns
#
# Params:
#   $1 : Variable name
#   $2 : Variable value
#   $3 : Level (default: info)
function log_var()
{
    local NAME=$1
    local VALUE=$2
    local LEVEL=${3:-$LOG_INFO}

    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
        if "$LOG_STEP" ; then
            printf "\n"
            LOG_STEP=false
        fi
        printf "[${LOG_PREFIX[$LEVEL]}] ${ORANGE}%${LOG_PADDING}s${NC}: ${BOLD}%s${NC}\n" "$NAME" "$VALUE"
    fi
}


# ----------------------------------------------------------
# Display debug footer
#
# Params:
#   $1 : Level (default: info)
function log_var_footer()
{
    local LEVEL=${1:-$LOG_INFO}
    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
        if "$LOG_STEP" ; then
            printf "\n"
            LOG_STEP=false
        fi
        printf "[${LOG_PREFIX[$LEVEL]}] "
        printf "=%.0s" $(eval "echo {1.."$(($LOG_PAGE_WITH))"}")
        printf "\n"
    fi
}
