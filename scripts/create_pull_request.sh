#!/bin/bash -xe
HUB="2.2.9"

# 認証情報を設定する
mkdir -p "$HOME/.config"
set +x
echo "https://${GH_TOKEN}:@github.com" > "$HOME/.config/git-credential"
echo "github.com:
- oauth_token: $GH_TOKEN
  user: $GH_USER" > "$HOME/.config/hub"
unset GH_TOKEN
set -x

# Gitを設定する
git config --global user.name  "${GH_USER}"
git config --global user.email "${GH_USER}@users.noreply.github.com"
git config --global core.autocrlf "input"
git config --global hub.protocol "https"
git config --global credential.helper "store --file=$HOME/.config/git-credential"

# hubをインストールする
curl -LO "https://github.com/github/hub/releases/download/v$HUB/hub-linux-amd64-$HUB.tgz"
tar -C "$HOME" -zxf "hub-linux-amd64-$HUB.tgz"
export PATH="$PATH:$HOME/hub-linux-amd64-$HUB/bin"

now=$(date "+%Y%m%d%H%M%S")

# リポジトリに変更をコミットする
hub clone "ghpage_sample"
cd _
hub checkout -b "jekyll_build_${now}"
## ファイルを変更する ##
hub status
hub add .
hub commit -m "jekyll build ${now}"

# Pull Requestを送る
hub push origin "jekyll_build_${now}"
hub pull-request -m "jekyll build ${now}"
cd ..
