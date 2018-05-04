#!/bin/bash

CONFIG_DIR=$HOME/.config/yov
PLAYLIST=${CONFIG_DIR}/playlist/$2.json

usage(){
  echo "Usage"
  echo -e "\tyov play [playlist]"
  echo -e "\tyov add  [playlist] [url]"
  echo -e "\tyov addlocal [playlist] [title] [uri]"
  echo "Require"
  echo -e "\tyoutube-dl"
  echo -e "\tjq"
}

if [ $# -lt 1 ] || !(type jq &> /dev/null) || !(type youtube-dl &> /dev/null); then
  usage
  exit
fi

addplaylist(){
  local playlist=$1
  local title=$2
  local uri=$3
  [ -d /tmp/yov ] || mkdir /tmp/yov &&
  cat $playlist | jq ".list|= .+[{\"title\":\"$title\",\"stream\":\"$uri\"}]" > /tmp/yov/list.json &&
  cat /tmp/yov/list.json > $playlist
}

if [ $1 = "init" ]; then
  mkdir -p $CONFIG_DIR/playlist &&
  echo '{"list":[],"name":"default"}' > $CONFIG_DIR/playlist/default.json
  exit
fi

if [[ $1 = "addlocal" ]]; then
  if [ "$4" = "" ] || [ "$2" = "" ] || [ "$3" = "" ]; then
    usage
    exit
  fi
  addplaylist $CONFIG_DIR/playlist/$2.json $3 file:///$4
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
  addplaylist $PLAYLIST $title $3
  echo "done!"
  exit
fi

if [[ $1 = "play" ]]; then
  if [ "$2" = "" ]; then
    PLAYLIST=$CONFIG_DIR/playlist/$(ls -1 $CONFIG_DIR/playlist/|shuf -n1)
  fi
  vlc ${YOV_VLC_OPTIONS}  $(cat $PLAYLIST|jq -cr '.list[].stream'|shuf|xargs) &> /dev/null &
fi
