# test.t
. ./funcs.sh
t_ok 1

DEFAULT_JSON=$HOME/.config/yov/playlist/default.json
URL='https://www.youtube.com/watch?v=4QFtAHfdTMU'
URL2="https://www.youtube.com/playlist?list=PLwW8DzvLo_xk87YjL2AATM7Bdts1pV319"

t::group "init" ({
  ./yov.sh init
  t_directory "$HOME/.config/yov/playlist"
  t_file "$HOME/.config/yov/playlist/default.json"
  default_playlist="$(cat $DEFAULT_JSON)"
  t_is "$default_playlist" '{"list":[],"name":"default"}'
})

t::group "help" ({
  t_error "./yov.sh"
  t_error "./yov.sh --help"
})

t::group "unit add playlist" ({
 ./yov.sh init
  __yov_addplaylist $DEFAULT_JSON a b
  RES=$(cat $DEFAULT_JSON|jq -cr '.list[0]')
  t_is "$RES" '{"title":"a","stream":"b"}'
  t_error "__yov_addplaylist" 
  t_error "__yov_addplaylist a"
  t_error "__yov_addplaylist $DEFAULT_JSON"
  t_error "__yov_addplaylist $DEFAULT_JSON a"

  t_error "./yov.sh add"
  t_error "./yov.sh add a"
  t_error "./yov.sh add d url"
  
  ./yov.sh init 
  ./yov.sh add default "$URL2"
  RES="$(cat $DEFAULT_JSON | jq -cr '.list[]|.stream' | sed -E 's/.+v=//g' | xargs)"
  t_is "$RES" "SQo6qcH6t5I P4a6_ROoUcM"
  
 ./yov.sh add default "$URL"
  cat $DEFAULT_JSON|jq -cr '.list[2]'
  RES="$(cat $DEFAULT_JSON|jq -cr '.list[2].stream')"
  t_is "$RES" "$URL"
  t_error "./yov.sh add default url"

})

t::group "unit listup" ({
  t_is "$(__yov_listup)" "$(__yov_listup default)"
  RES="$(__yov_listup|tail -n1|awk '{print $NF}')"
  t_is $RES $URL
  export YOV_FUZZY_FINDER="fzf"
  export YOV_FUZZY_FINDER_OPTIONS="--select-1"
 ./yov.sh init
  __yov_addplaylist $DEFAULT_JSON a b
  t_is "b" "$(__yov_choice)"
  export YOV_FUZZY_FINDER=peco
  t_is "b" "$(__yov_choice)"
})

t::group "unit addlocal" ({
  t_ok 1 "unit test [addlocal functions]"
  t_error "./yov.sh addlocal"
  t_error "./yov.sh addlocal a"
  t_error "./yov.sh addlocal a b"
  t_error "./yov.sh addlocal a b c"
 ./yov.sh init
 ./yov.sh addlocal default title stream
  RES="$(cat $DEFAULT_JSON|jq -rc '.list[0].stream')"
  t_is "$RES" "file:///stream"
  RES="$(cat $DEFAULT_JSON|jq -rc '.list[0].title')"
  t_is "$RES" "title"
 ./yov.sh addlocal default title2 stream2
  RES="$(cat $DEFAULT_JSON|jq -rc '.list[1].stream')"
  t_is "$RES" "file:///stream2"
  RES="$(cat $DEFAULT_JSON|jq -rc '.list[1].title')"
  t_is "$RES" "title2"
})

