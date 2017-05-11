#!/usr/bin/env bash

# Upgrade system
alias upg="sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y"

# Remove all untagged / unfinished docker images
alias drminone="if [ \$(docker images -q --filter dangling=true | wc -l) -gt 0 ] ; then ; docker rmi -f \$(docker images -q --filter dangling=true) ; fi"


# Launch SyncThing UI
alias syncthing-ui="chromium-browser --user-data-dir=\$HOME/.config/syncthing-ui --app=http://127.0.0.1:8384/ &"
