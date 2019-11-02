#!/usr/bin/env zsh

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
  # Newline strategy from https://unix.stackexchange.com/a/140769 and for Mac OS
  # specifically https://superuser.com/a/307486
  binaries=($(sed -E '/Commands available/!d;s/.*Commands available from binary scripts: ([^"]+)".*/\1/;s/.*"items":\[([^]]+).*/\1/;s/[" ]//g;s/:/\\:/g;s/,/\'$'\n/g' <<< "$runJSON"))
  scriptNames=($(sed -E '/possibleCommands/!d;s/.*"items":\[([^]]+).*/\1/;s/[" ]//g;s/:/\\:/g;s/,/\'$'\n/g' <<< "$runJSON"))
  scriptCommands=("${(@f)$(sed -E '/possibleCommands/!d;s/.*"hints":\{([^}]+)\}.*/\1/;s/"[^"]+"://g;s/:/\\:/g;s/","/\'$'\n/g;s/(^"|"$)//g' <<< "$runJSON")}")
  # scriptCommands=("${(@f)$(sed -E '/possibleCommands/!d;
  # s/.*"hints":\{([^}]+)\}.*/\1/;
  # s/"[^"]+"://g;
  # s/:/\\:/g;
  # s/","/\'$'\n/g;
  # s/(^"|"$)//g' \
  # <<< "$runJSON")}")
  echo "$scriptCommands"
  echo
  echo
  echo "scriptCommands length:"
  echo $scriptCommands[(I)$scriptCommands[-1]]
  echo
  echo
  for sc in "${scriptCommands[@]}"
  do
    echo "$sc"
  done

  exit 0

  # for (( i=1; i <= $#scriptNames; i++ )); do
  #   scripts+=("${scriptNames[$i]}:${scriptCommands[$i]}")
  # done

  commands=($scripts $binaries)


  echo -e "\n\nbinaries first element: $binaries"
  echo -e "binaries are"
  for bin in "${binaries[@]}"
  do
    echo "$bin"
  done

  echo -e "\n\nscript names first element: $scriptNames"
  echo -e "script names are:"
  for sn in "${scriptNames[@]}"
  do
    echo "$sn"
  done

  echo -e "\n\nscript commands first element: $scriptCommands"
  echo "script commands are:"
  for sc in "${scriptCommands[@]}"
  do
    echo "$sc"
  done
  # _describe 'command' commands
}

_yarn_scripts