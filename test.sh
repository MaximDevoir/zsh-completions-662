#!/usr/bin/env bash

# Exit immediately if a command returns a non-zero status
# set -e

# Exit when references variables are undefined
# set -u

# Print the executed command
# set -x



echo "running tests"



_yarn_scripts() {
  local -a commands binaries scripts
  local -a scriptNames scriptCommands
  local i runJSON

  runJSON=$(yarn run --json 2>/dev/null)
  binaries=($(sed -E '/Commands available/!d;s/.*Commands available from binary scripts: ([^"]+)".*/\1/;s/.*"items":\[([^]]+).*/\1/;s/[" ]//g;s/:/\\:/g;s/,/\n/g' <<< "$runJSON"))
  scriptNames=($(sed -E '/possibleCommands/!d;s/.*"items":\[([^]]+).*/\1/;s/[" ]//g;s/:/\\:/g;s/,/\n/g' <<< "$runJSON"))
  # scriptCommands=("${(@f)$(sed -E '/possibleCommands/!d;s/.*"hints":\{([^}]+)\}.*/\1/;s/"[^"]+"://g;s/:/\\:/g;s/","/\n/g;s/(^"|"$)//g' <<< "$runJSON")}")


  # for (( i=1; i <= $#scriptNames; i++ )); do
  #   scripts+=("${scriptNames[$i]}:${scriptCommands[$i]}")
  # done

  commands=($scripts $binaries)


  echo -e "\n\nbinaries are"
  for bin in "${binaries[@]}"
  do
    echo "$bin"
  done

  echo -e "\n\nscript names are:"
  for sn in "${scriptNames[@]}"
  do
    echo "$sn"
  done

  # _describe 'command' commands
}

_yarn_scripts