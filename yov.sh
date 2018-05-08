#!/bin/bash

CONFIG_DIR=$HOME/.config/yov
SCRIPT_PATH="$(cd $(dirname $0) && pwd)"

### source functions
source $SCRIPT_PATH/funcs.sh

### main 
([ "$1" = "--help" ] || [ $# -lt 1 ] || [ ! -w type jq &> /dev/null ] || [ ! -w type youtube-dl &> /dev/null ]) && __yov_usage && exit 1

[ "$1" = "init" ] && __yov_init && exit

if [[ $1 = "addlocal" ]]; then
  ([ "$4" = "" ] || [ "$2" = "" ] || [ "$3" = "" ]) && __yov_usage && exit 1
  [ ! -f $CONFIG_DIR/playlist/$2.json ] && echo could not find $2.json && exit 1
  __yov_addplaylist $CONFIG_DIR/playlist/$2.json $3 file:///$4 && exit
fi

[[ $1 = "select" ]] && target="$(__yov_select $2)" && vlc "$target" &> /dev/null &

if [[ $1 = "add" ]]; then
  PLAYLIST=$CONFIG_DIR/playlist/$2.json
  ([[ "$2" = "" ]] || [[ "$3" = "" ]]) && __yov_usage && exit 1
  [ ! -f $PLAYLIST ] && echo could not find $PLAYLIST && exit 1

  [ -d /tmp/yov ] || mkdir /tmp/yov &&
    youtube-dl -J $3 > /tmp/yov/get.json && echo "get json from internet" && 
    title="$(cat /tmp/yov/get.json | jq -cr '.title')" && echo "get title:$title($3)" && 
    __yov_addplaylist $PLAYLIST "$title" "$3" || exit 1
  echo "done!" && exit
fi

[[ $1 = "play" ]] && __yov_play "$2"

