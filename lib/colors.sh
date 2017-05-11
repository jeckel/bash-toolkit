#!/usr/bin/env bash

# ======================================================================================================================
# Author: Julien Mercier
# Email: jeckel@jeckel.fr
# License: MIT
#
# Define common colors and styles
#
# @see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

if ! declare -f module &>/dev/null; then
	echo "This file should not be loaded directly, load 'main.sh' and the use the 'module' function"
fi

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly ORANGE='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly RED_B='\033[0;31m\033[1m'
readonly GREEN_B='\033[0;32m\033[1m'
readonly ORANGE_B='\033[0;33m\033[1m'
readonly BLUE_B='\033[0;34m\033[1m'
readonly PURPLE_B='\033[0;35m\033[1m'
readonly CYAN_B='\033[0;36m\033[1m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'
readonly NEGATIV='\033[7m'
