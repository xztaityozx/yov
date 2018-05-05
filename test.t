# add.t
. ./yov.sh

yov init

t_directory "$HOME/.config/yov/playlist"
t_file "$HOME/.config/yov/playlist/default.json"

default_playlist="$(cat $HOME/.config/yov/playlist/default.json)"
t_is "$default_playlist" '{"list":[],"name":"default"}'

t_error "yov"
t_error "yov --help"
