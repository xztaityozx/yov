
CONFIG_DIR=$HOME/.config/yov
__yov_usage(){
  echo "Usage"
  echo -e "\tyov play [playlist]"
  echo -e "\tyov add  [playlist] [url]"
  echo -e "\tyov addlocal [playlist] [title] [uri]"
  echo -e "\tyov select [playlist]"
  echo "Require"
  echo -e "\tyoutube-dl"
  echo -e "\tjq"
}

__yov_addplaylist(){
  local playlist=$1
  local title=$2
  local uri=$3
  [ "$playlist" = "" ] || [ "$title" = "" ] || [ "$uri" = "" ] && return 1
  [ -d /tmp/yov ] || mkdir /tmp/yov &&
    cat $playlist | jq ".list|= .+[{\"title\":\"$title\",\"stream\":\"$uri\"}]" > /tmp/yov/list.json &&
    cat /tmp/yov/list.json > $playlist
}
__yov_listup(){
  local playlist=$CONFIG_DIR/playlist/${1:-default}.json
  cat $playlist | jq -cr '.list[]|.title,.stream' | awk 'NR%2==1{printf "[%d]\t"$0,NR/2}NR%2==0{print "\t"$0}'
}

__yov_choice(){
  local choiced=$(__yov_listup $1|$YOV_FUZZY_FINDER $YOV_FUZZY_FINDER_OPTIONS)
  [ "$choiced" = "" ] && return 1
  echo $choiced | awk '{print $NF}'
}

__yov_select(){
  local selected=$(__yov_choice $1) && echo "$selected"
}

__yov_play(){
  local PLAYLIST=$CONFIG_DIR/playlist/"$1".json
  [ "$1" = "" ] && PLAYLIST=$CONFIG_DIR/playlist/$(ls -1 $CONFIG_DIR/playlist/|shuf -n1)
  vlc $YOV_VLC_OPTIONS $(cat $PLAYLIST|jq -cr '.list[].stream'|shuf|xargs) &> /dev/null &
}

__yov_init(){
  mkdir -p $CONFIG_DIR/playlist &&
    echo '{"list":[],"name":"default"}' > $CONFIG_DIR/playlist/default.json
}

__yov_getYoutubePlaylist(){
  local URL="$2"
  local playlist="$1"

  [ -d /tmp/yov ] || mkdir /tmp/yov &&
  echo get youtube playlist... &&
  youtube-dl -J --flat-playlist "$URL" > /tmp/yov/get.json &&
  echo parse JSON... &&
  cat /tmp/yov/get.json | jq -cr '.entries[]|.title,.id' | tee /tmp/yov/list.json &&
  echo add to $playlist &&
  cat /tmp/yov/list.json | 
  awk 'NR%2==1{printf "{\"title\":\""$0"\","}NR%2==0{print "\"stream\":\"https://www.youtube.com/watch?v="$0"\"}"}' | 
  tr '\n' ',' | sed 's/,$//' | awk 1 > /tmp/yov/querys &&
  cat $playlist | jq ".list|= .+[$(cat /tmp/yov/querys)]" > /tmp/yov/list.json && 
  cat /tmp/yov/list.json > $playlist &&
  echo "done!"
}
