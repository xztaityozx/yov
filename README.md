# yov
youtube on vlc

Jsonで作ったプレイリストをコンソールからvlcに再生させるオレオレスクリプト

## install
```sh
git clone https://github.com/xztaityozx/yov
chmod +x yov/yov.sh
yov/yov.sh init
```

## Require
- [youtube-dl](https://github.com/rg3/youtube-dl)
  - URLからJsonを取得して、動画タイトルを抜き出すのに使う
- [jq](https://stedolan.github.io/jq/)
  - Jsonの解析に使う

## Usage
```sh
yov.sh add [playlist] [url]
```
URLをplaylistに追加する。`youtube-dl`でタイトルを取得できるなら取得する  
Youtubeの再生リストのURLを指定すると再生リストを全部取得して追加する

```sh
yov.sh addlocal [playlist] [title] [uri]
```
ローカルとかにあるファイルを指定してプレイリストに追加できる。絶対パスを指定すること

```sh
yov.sh play [playlist]
```
playlistを再生する。空白にしたら`$HOME/.config/yov/playlist/`からランダムに選ばれる
playlistはランダムに再生される

```sh
yov.sh select [playlist]
```
[fzf](https://github.com/junegunn/fzf)や[peco](https://github.com/peco/peco)みたいなFuzzy Finderを使って1曲だけ選択して再生します。使うFuzzy Finderは`YOV_FUZZY_FINDER`に、コマンドのオプションは`YOV_FUZZY_FINDER_OPTIONS`に`export`しておいてください

## Uninstall
```sh
rm -rf yov
rm -rf $HOME/.config/yov
```

## Playlistのフォーマット
```json
{
  "list":[
    {
      "title":"曲のタイトル",
      "stream":"URLとかファイルパス"
    },
    ...
  ],
  "name":"プレイリストの名前"
}
```
