#!/usr/bin/env bash

# ======================================================================================================================
# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT

# ----------------------------------------------------------
# Declare global variables
BT_loaded_modules=()
BT_PATH=""
BT_LIB_PATH=""

# ----------------------------------------------------------
# Return current library absolute path
# @usage
#    PATH=$(get_main_path)
#
# @param    -
# @variable -
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
# Load a module if not already loaded
# @usage
#	module logs
#
# @param    module name
# @variable $BT_loaded_modules is read and update
function module() {
	local MODULE=$1
	for i in "${BT_loaded_modules[@]}"
	do
		if [ "$i" == "$MODULE" ] ; then
			return
		fi
	done
	BT_loaded_modules+=(${MODULE})
	source "$BT_LIB_PATH/$MODULE.sh"
}

# ----------------------------------------------------------
# Initialize library
# @usage
#	__init
#
# @param    -
# @variable $BT_PATH is updated
# @variable $BT_LIB_PATH is updated
function __init() {
	BT_PATH=$(get_main_path)
	BT_LIB_PATH="$BT_PATH/lib"
}

__init

# ----------------------------------------------------------
# Load libraries
#
#module colors
#module logs
#module docker
