[![Twitter](https://img.shields.io/badge/Twitter-%40jeckel4-blue.svg)](https://twitter.com/intent/user?screen_name=jeckel4) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Julien%20Mercier-blue.svg)](https://www.linkedin.com/in/jeckel/)

# Bash ToolKit
Bash scripts and tools

## Usages

### In your scripts

To use this toolkit in your own `bash` scripts just start your script with the following lines :
```bash
# Load framework
readonly BIN="$(dirname "$0")"
source ${BIN}/../main.sh
```

Replace the path to the `main.sh` according to your installation.

Then you can load the modules you want with the `module` command :

```bash
module colors
module logs
module docker
```

### In [Monit](https://www.mmonit.com/monit/)'s configuration file for docker

You can use this Toolkit to monitor docker's container with [Monit](https://www.mmonit.com/monit/).

Here is a sample config you can use for monitoring a container named `portainer` :

```monit
check program docker_portainer with path <path_to_toolkit>/scripts/docker_monit.sh -s portainer
      if status != 0 then alert
      start program "<path_to_toolkit>/scripts/docker_monit.sh -s portainer start"
      stop program "<path_to_toolkit>/scripts/docker_monit.sh -s portainer stop"
```

Don't forget to replace <path_to_toolkit> with the install directory of this toolkit.

## Modules

### colors

This module is used by other modules, it define some ANSI constants to use colors in your script.

### logs

This module provide a list of usefull methods to display fancy log during the execution of your scripts.

### docker

This module provide a list of function to manipulates docker container, with secure dependencies, and with fancy log messages.



## Resources

* ["Usage" message](https://en.wikipedia.org/wiki/Usage_message) or *How to show help in scripts?*
* [How to handle command line arguments](http://mywiki.wooledge.org/BashFAQ/035)
* [Small `getopts` tutorial](http://wiki.bash-hackers.org/howto/getopts_tutorial)
* [Bash parameters and parameter expansions](https://www.ibm.com/developerworks/library/l-bash-parameters/index.html)
* [Conditions in Bash scripting (`if` statements)](https://linuxacademy.com/blog/linux/conditions-in-bash-scripting-if-statements/)
* [4 bash `if` statements example](http://www.thegeekstuff.com/2010/06/bash-if-statement-examples/)
* [ANSI Escape Sequences](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/c327.html)
* [Returning values from Bash functions](http://www.linuxjournal.com/content/return-values-bash-functions)

### Makefile
* [Makefile statements](http://makepp.sourceforge.net/1.19/makepp_statements.html)
* [Introduction à Makefile](http://gl.developpez.com/tutoriel/outil/makefile/) :fr:

### Screen
* [Split screen reminders](https://unix.stackexchange.com/questions/7453/how-to-split-the-terminal-into-more-than-one-view#7455)

### Misc
* [10 tools to add some spice to your UNIX shell scripts](https://www.cyberciti.biz/tips/spice-up-your-unix-linux-shell-scripts.html)

### Bash Framework
* [Bashinator](https://github.com/wschlich/bashinator)
* [Bashworks](https://github.com/jpic/bashworks)
