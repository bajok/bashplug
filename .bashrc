#! /bin/bash

VERSION=0.15

[[ $- != *i* ]] && return
if [ "$UID" == "0" ]; then PS1="  \[\033[00;31;44m\]\u@\h \[\033[01;34m\]\w # \[\033[00m\]";
else                       PS1="  \[\033[00;40;95m\]\u@\h \[\033[01;97m\]\w $ \[\033[00m\]"; fi

set -o nounset
shopt -s histappend                    # append to the history file, don't overwrite it
shopt -s checkwinsize                  # update window size after each cmd (if necessary)

export GREP_COLOR="mt=1;35"
export HISTCONTROL=ignoreboth          # ignoredups & ignorespace
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export JAVA_HOME=/usr/lib/jvm/default
export PATH=$PATH:.:~/scripts:~/.bashplug/scripts

if [ -d ~/.bashplug ]
then
  source ~/.bashplug/control
  source ~/.bashplug/functions
  source ~/.bashplug/aliases
  source ~/.bashplug/net
  source ~/.bashplug/stats
else
  echo "~/.bashplug not present"
fi

if [ -f ~/.bashplug/aliases-local ]; then # use this file for local machine aliases, like cdX='cd ~/X' and so
  source ~/.bashplug/aliases-local
fi

prnt_head "TODO"
cat ~/TODO
prnt_head " "

