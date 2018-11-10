#!/usr/bin/bash -e

#set -x

SCRIPT=$(basename $0)
BASED_URL=https://github.com/King-1025/ym/raw/master

function recycle_download()
{
  if [ $# -eq 2 ]; then
    local target=$BASED_URL"/$1"
    local count=$2
    if [[ "$count" = *[!0-9]* ]]; then
      echo "count must be number! count:$count"
      exit 1
    fi
    if [ "$count" = "" ]; then count=1; fi
    local file_size="--"
    echo -e "start testing...\n"
    for ((i=0;i<$count;i++)); do
       local tmp=$(mktemp -u)
       echo -n "-> $i:fetch $target"
       curl -sL -o $tmp $target
       if [ "$file_size" = "--" ]; then
	  file_size=$(du -h $tmp | awk '{print $1}')
       fi
       echo -e " ok!\n"
       rm -rf $tmp
       sleep 0.5
    done
    echo $(date "+%F %H:%M:%S")" $count*$file_size "$(echo "scale=2;${file_size:0:-1}*$count" | bc)
  fi
}

function ym_test()
{
  if [ $# -eq 2 ]; then
     if [ "$1" = "0.5M" ]; then
        recycle_download "F-512K" $2
     elif [ "$1" = "1M" ]; then
        recycle_download "F-1M" $2
     elif [ "$1" = "2M" ]; then
        recycle_download "F-2M" $2
     elif [ "$1" = "5M" ]; then
        recycle_download "F-5M" $2
     elif [ "$1" = "10M" ]; then
        recycle_download "F-10M" $2
     else
	echo "Usage:$SCRIPT <0.5M|1M|2M|5M|10M> count"
     fi
  fi
}

ym_test $*
