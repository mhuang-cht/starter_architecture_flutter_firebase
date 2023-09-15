#! /bin/bash

repo="$1"
github_user="mhuang-cht"

if [ -z "$repo" ]; then
    echo Usage: $(basename $0) repo_name
    exit 1
fi

rm -fr .git
echo "README for $repo" > README.md
set -xe
git init
git add .
git commit -m "first commit after change the app name"
git remote add origin git@github.com:$github_user/$repo.git
git push -u origin master
