#! /bin/bash

source ~/.bashplug/control

PATTERN="$1"
COMMAND="$2"

FILEARRAY=()

function usage()
{
  prnt_summ "$0 usage:"
  prnt_info "$0 <pattern> [command]"  # command is optional. check if proper files matched
  prnt_info "$0 *.zip unzip"
  exit
}

if [ -z $PATTERN ]; then usage; exit; fi

function getfiles()
{
  local input="$1"

  shopt -s globstar nullglob # dotglob to match hidden files also
  FILEARRAY=( **/*"$input"* )
}

getfiles "$1"

if [ -z "$COMMAND" ]
then
  prnt_info "found files:"
  for file in ${FILEARRAY[@]}
  do
    echo "$file"
  done
  prnt_info "but no command provided."
else
  for file in ${FILEARRAY[@]}
  do
    echo $COMMAND $file
    eval $COMMAND $file
  done
fi

