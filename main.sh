#!/usr/bin/env bash

# ----------------------------------------------------------
# Return current library absolute path
#
# Usage :
#    PATH=$(get_main_path)
function get_main_path
{
    local SOURCE="${BASH_SOURCE[0]}"
    local DIR

    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    echo "$DIR"
}

# ----------------------------------------------------------
# Define paths
#
BT_PATH=$(get_main_path)
BT_LIB_PATH="$BT_PATH/lib"

# ----------------------------------------------------------
# Load libraries
#
source "$BT_LIB_PATH/colors.sh"
source "$BT_LIB_PATH/logs.sh"
source "$BT_LIB_PATH/docker.sh"