#! /bin/bash

SKIP_NODE_MODULES="yeah"
PRINT_LINE_NUMBERS="sure"
ASKTOVIM="aye"
export GREP_COLORS="1;33" 
export GREP_COLOR="0;32" # deprecated - sets color
C_lnk="\033[4;40;34m"; C_rnk=" \033[1;30;34m"; C_rst="\033[0;39;00m"
Chctl="\033[1;31;40m.\033[0;00;00m"
Chbin="\033[1;31;40mb\033[0;00;00m"
dots()      { sleep 0.0104s; echo -ne "$Chctl"; }
prnt_help() { echo -ne "$@\n"; }; usage() {
  local scrname=`basename $0`
  prnt_help "\033[1;39;44m""usage:$C_rst"
  prnt_help "  $scrname                          displays help"
  prnt_help "  $scrname strING                   search . for strING"
  prnt_help "  $scrname strING filter            search . for strING and filter"
  echo; exit
}; if [ "$1" == "" ]; then usage; fi
get_filelist()
{ 
  local recursive="yes"
  if   [[ "$1" =~ [-]R[0-9]* ]]; then
    local maxd=`echo $1 | cut -f2 -dR`
    FILELIST=`find . -maxdepth $maxd | grep -v node_modules`   # TODO: if
  elif [[ "$1" =~ [+]R[0-9]* ]]; then
    # TODO recursive search in upper dirs
    local mind=`echo $1 | cut -f2 -dR`
    local path="../"           # TODO print ../ in number that equals +R
    FILELIST=`find $level`
  else                                 # no [-+]R param used
    recursive="no"
    FILELIST=`ls -A .`                 # only current directory
  fi
  if [ "$recursive" == "yes" ]; then
    GREP_STR="$2"
    FILTER_S="$3"
  else
    GREP_STR="$1"
    FILTER_S="$2"
  fi
}
prnt_filename()    { echo -ne "\n$C_lnk""$1""$C_rst\n"; }
#indentize()        { echo "$1" | gawk '{ num=length($0); for (i=0;i<num;i++) ind=ind"*"; gsub("$0", ind); print ind; }'; }
out_grep_str()
{ 
  # $1: line_num
  # $2: buffer
  if [ "$PRINT_LINE_NUMBERS" == "sure" ]; then
    local line_num="\033[0;30;31m""$1""$C_rst"
  else
    local line_num=""
  fi
  # check filter string
  if [ "$FILTER_S" != "" ]; then
    local output_s=`echo "$2" | grep --color=always $FILTER_S`
  else
    local output_s="$2"
  fi
  # save indent. ++indent for each new digit. 1-1, 10-2, 100-3, 1000-4, 10000-5
  #TODO
  #local indent1=`indentize $ITER`
  #local indent2=`indentize $line_num`
  #echo -ne "$C_rnk""$ITER$indent1""$C_rst ""$line_num: $indent2""$output_s\n"
  # do indent different way:
  # get number of results (digits 1-1, 10-2, etc) and skip line num indentation
  echo -ne "$C_rnk""$ITER""$C_rst ""$line_num: ""$output_s\n"
}

ITER=1
RESULT_TABLE[0]=init
MAYBINARY="Binary file (standard input) matches"

serialize_and_print_buffer()
{ # $1: filename
  # $2: GREP_BUFFER
  #prnt_filename "$FILE_STRING"
  # go line after line in buffer:
  local lines_tg=`echo "$2" | wc -l` # to go, 
  for ((i=1; i<=$lines_tg; i++))
  do
    local line_str=`echo "$2" | sed -n "$i""p"`  # getline
    local line_num=`echo "$line_str" 2>&1 | cut -f1 -d:`
    local grep_res=`echo "$line_str" | cut -f1 -d: --complement`
    RESULT_TABLE[$ITER]="$1:$line_num" # save to open later.
    out_grep_str $line_num "$grep_res" | grep --color=always $GREP_STR
    ITER=$((ITER+1))
  done
}
open_file() 
{ # $1: path:num
  local filename=`echo "$1" | cut -f1 -d:`
  local line_num=`echo "$1" | cut -f2 -d:`
  vim +$line_num  $filename
}
ask_to_display_result()
{
  if [ "$ASKTOVIM" != "no" ]; then echo -ne "open: "; read NUMBER
    while [ "$NUMBER" -gt 0 -a "$NUMBER" -lt $ITER ]; do
      echo -ne "open: "
      open_file         ${RESULT_TABLE[NUMBER]}
      read NUMBER
    done
  fi
}
# E492: Not an editor command: ^[[32m^[[K457^[[m^[[K^[[36m^[[K
get_filelist $@                        # GREP_STR is set
#echo $FILELIST

if [ "$GREP_STR" == "" ]; then echo "provide search string"; usage; fi

echo 
for file in $FILELIST
do
  if [ -f $file ]; then
    FILE_STRING="$C_lnk""$file""$C_rst"
    GREP_BUFFER=`cat $file | grep --color=never -n $GREP_STR`
    if   [ -z "$GREP_BUFFER" ]; then dots
    elif [ "$GREP_BUFFER" == "$MAYBINARY" ]; then
      echo -ne "$Chbin"
    else
      prnt_filename "$FILE_STRING"
      serialize_and_print_buffer "$file" "$GREP_BUFFER"
    fi
  fi
done

# use vim to display result?
if [ "$ITER" -gt 1 ]; then
  echo
  ask_to_display_result
else
  echo -ne "\033[0;31m\nnothing\n"
fi
#
