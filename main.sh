#!/usr/bin/env bash

# ======================================================================================================================
# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT

# ----------------------------------------------------------
# Environment variables
#
# This variables can be set from outsite this ToolKit to setup
# default values or change default behaviour
# All this environment variables should start by BTK
#
# BTK_PATH : this variable can be set to force the path to the ToolKit


# ----------------------------------------------------------
# Declare global variables
#
# All global variables related by this ToolKit should start by __BTK

__BTK_PATH=${BTK_PATH:-""}      # Absolute path to the current ToolKit main.sh
__BTK_LOADED_MODULES=()         # List of loaded modules
__BTK_LIB_PATH=""               # Absolute path to the library folder

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
# @variable $__BTK_LOADED_MODULES is read and updated
# @variable $__BTK_LIB_PATH is read
function module() {
	local MODULE=$1
	for i in "${__BTK_LOADED_MODULES[@]}"
	do
		if [[ "$i" == "$MODULE" ]] ; then
			return
		fi
	done
	BT_loaded_modules+=(${MODULE})
	source "$__BTK_LIB_PATH/$MODULE.sh"
}

# ----------------------------------------------------------
# Initialize library
# @usage
#	__init
#
# @param    -
# @variable $__BT_PATH is updated
# @variable $__BTK_LIB_PATH is updated
function __init() {
	if [ -z $__BTK_PATH ]; then
		__BTK_PATH=$(get_main_path)
	fi
	__BTK_LIB_PATH="$__BTK_PATH/lib"
}

__init

# ----------------------------------------------------------
# Load libraries
#
#module colors
#module logs
#module docker
