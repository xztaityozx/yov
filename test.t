# add.t
. ./yov.sh

DEFAULT_JSON=$HOME/.config/yov/playlist/default.json

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
  URL='https://www.youtube.com/watch?v=4QFtAHfdTMU'
  yov add default $URL
  cat $DEFAULT_JSON|jq -cr '.list[1]'
  RES=$(cat $DEFAULT_JSON|jq -cr '.list[1].stream')
  t_is $RES $URL
  t_error "yov add default url"
})
