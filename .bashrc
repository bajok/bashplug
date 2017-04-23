#! /bin/bash

# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# .bashplug
#
# a set of functions, aliases and scripts
# see docs:
# [todo]
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

BASHPLUG_VERSION=0.12

[[ $- != *i* ]] && return
if [ "$UID" == "0" ]; then PS1="  \033[00;31m\u@\h \033[01;34m\w # \033[00m"; 
else                       PS1="  \033[00;32m\u@\h \033[01;34m\w $ \033[00m"; fi

PATH=$PATH:.:~/.bashplug

if [ -d ~/.bashplug ]
then
  source ~/.bashplug/control
  source ~/.bashplug/aliases
  source ~/.bashplug/funcdef
  source ~/.bashplug/_todos_
  prnt_summ "bashplug files sourced: version $BASHPLUG_VERSION"
else
  echo "directory ~/.bashplug not present"
fi

export HISTCONTROL=ignoreboth          # ignoredups & ignorespace
shopt -s histappend                    # append to the history file, don't overwrite it
shopt -s checkwinsize                  # update window size after each cmd (if necessary)

export GREP_COLOR="1;35"

