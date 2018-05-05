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

```sh
yov.sh addlocal [playlist] [title] [uri]
```
ローカルとかにあるファイルを指定してプレイリストに追加できる。絶対パスを指定すること

```sh
yov.sh play [playlist]
```
playlistを再生する。空白にしたら`$HOME/.config/yov/playlist/`からランダムに選ばれる
playlistはランダムに再生される

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
