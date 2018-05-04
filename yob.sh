#!/bin/bash

CONFIG_DIR=$HOME/.config/yov
PLAYLIST=${CONFIG_DIR}/playlist/$2.json

usage(){
  echo "Usage"
  echo -e "\tyov play [playlist]"
  echo -e "\tyov add  [playlist] [url]"
  echo "Require"
  echo -e "\tyoutube-dl"
  echo -e "\tjq"
}

if [ $# -lt 1 ] || !(type jq &> /dev/null) || !(type youtube-dl &> /dev/null); then
  usage
  exit
fi
if [[ $1 = "add" ]]; then
  if [[ "$2" = "" ]] || [[ "$3" = "" ]]; then
    usage
    exit
  fi
  if [ ! -f $PLAYLIST ];then
    echo could not find $PLAYLIST
    exit
  fi
  [ -d /tmp/yov] || mkdir /tmp/yov &&
  youtube-dl -J $3 > /tmp/yov/get.json &&
  title=$(cat /tmp/yov/get.json | jq -cr '.title') &&
  cat $PLAYLIST | jq ".list |= .+[{\"title\":\"$title\",\"stream\":\"$3\"}]" > /tmp/yov/result.json &&
  cat /tmp/yov/result.json > $PLAYLIST
  echo "done!"
  exit
fi

if [[ $1 = "play" ]]; then
  if [ "$2" = "" ]; then
    PLAYLIST=$CONFIG_DIR/playlist/$(ls -1 $CONFIG_DIR/playlist/|shuf -n1)
  fi
  vlc ${YOV_VLC_OPTIONS}  $(cat $PLAYLIST|jq -cr '.list[].stream'|shuf|xargs) &> /dev/null &
fi
