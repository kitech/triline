git reflog expire --expire-unreachable="now" --all
git prune --expire="now" -v
git gc --aggressive --prune="now"

