# add.t
. ./yov.sh

DEFAULT_JSON=$HOME/.config/yov/playlist/default.json
URL='https://www.youtube.com/watch?v=4QFtAHfdTMU'

t::group "init" ({
  yov init
  t_directory "$HOME/.config/yov/playlist"
  t_file "$HOME/.config/yov/playlist/default.json"
  default_playlist="$(cat $DEFAULT_JSON)"
  t_is "$default_playlist" '{"list":[],"name":"default"}'
})

t::group "help" ({
  t_error "yov"
  t_error "yov --help"
})

t::group "unit add playlist" ({
  yov init
  __yov_addplaylist $DEFAULT_JSON a b
  RES=$(cat $DEFAULT_JSON|jq -cr '.list[0]')
  t_is $RES '{"title":"a","stream":"b"}'
  t_error "__yov_addplaylist" 
  t_error "__yov_addplaylist a"
  t_error "__yov_addplaylist $DEFAULT_JSON"
  t_error "__yov_addplaylist $DEFAULT_JSON a"

  t_error "yov add"
  t_error "yov add a"
  t_error "yov add d url"
  yov add default $URL
  cat $DEFAULT_JSON|jq -cr '.list[1]'
  RES=$(cat $DEFAULT_JSON|jq -cr '.list[1].stream')
  t_is $RES $URL
  t_error "yov add default url"
})

t::group "unit listup" ({
  t_is "$(__yov_listup)" "$(__yov_listup default)"
  RES="$(__yov_listup|tail -n1|awk '{print $NF}')"
  t_is $RES $URL
  YOV_FUZZY_FINDER="fzf"
  YOV_FUZZY_FINDER_OPTIONS="--select-1"
  yov init
  __yov_addplaylist $DEFAULT_JSON a b
  t_is "b" "$(__yov_choice)"
  YOV_FUZZY_FINDER=peco
  t_is "b" "$(__yov_choice)"
})
