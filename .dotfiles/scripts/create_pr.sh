#!/bin/sh
remote=$(git remote get-url origin)
repo=$(echo "$remote" | sed -nE 's/.+:(.+)\.git$/\1/p')
branch=$(git symbolic-ref --short HEAD)
case $remote in
    git@bitbucket.org:*)
        open "https://bitbucket.org/$repo/pull-requests/new?source=$branch&t=1"
        ;;
    git@github.com:*)
        open "https://github.com/$repo/compare/master...$branch"
        ;;
    *)
        echo "Can't open a PR for $remote"
        exit 1
        ;;
esac
