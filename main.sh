#!/usr/bin/env bash

# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT

BT_loaded_modules=()

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

# Load a module if not already loaded
#
# @param module name
# @variable BT_loaded_modules Add loaded modules
function module() {
	local MODULE=$1
	for i in "${BT_loaded_modules[@]}"
	do
		if [ "$i" == "$MODULE" ] ; then
#			echo "Already loaded"
			return
		fi
	done
	BT_loaded_modules+=(${MODULE})
	source "$BT_LIB_PATH/$MODULE.sh"
}



# ----------------------------------------------------------
# Load libraries
#
#module colors
#module logs
#module docker
