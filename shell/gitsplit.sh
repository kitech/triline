#!/bin/sh

# usage: gitsplit.sh dest-dir src-dir <dir1> <dir2> <dir3>...

SELFDIR=$(dirname $(readlink -f $0))
echo $SELFDIR
CURDIR=$PWD

DESTDIR=$(readlink -f $1)
SRCDIR=$(readlink -f $2)

GIT_USER="gzleo"
GIT_EMAIL="yatseni5@gmail.com"
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_USER"

#############
set -x

ARGV=$@
ARGC=${#@}
DIRS=${@:3:99}

#######
if [ ! -d "$SRCDIR" ]; then
    echo "src dir not exist: $SRCDIR"
fi

cd "$SRCDIR"

### check dirs
AllExist=1
for dir in $DIRS; do
    echo "Spliting $dir ..."
    if [ ! -d "$dir" ]; then
        AllExist=0
    fi
done

echo "All exist: $AllExist."

for dir in $DIRS; do
    echo "Spliting $dir ..."
    # git subtree split --prefix "$dir" -b "$dir"
done

echo "Add dir to new repo...$DESTDIR"
if [ x"$DESTDIR" == x"" ];then
    echo "must set DESTDIR!!! will clean."
    exit
fi
mkdir -p "$DESTDIR"
rm -rf "$DESTDIR/.git"
rm -rf "$DESTDIR"/*

cd "$DESTDIR"
git init
echo  > inited.md
git add inited.md
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_USER"
git commit -a -m "intied"

ls -lh "$DESTDIR"
for dir in $DIRS; do
    echo "Adding $dir ..."
    git subtree add --prefix "$dir" "$SRCDIR" "$dir"
done
ls -lh "$DESTDIR"
git log --oneline | head -n 5

exit

cd $SELFDIR
git subtree split --prefix src/zend -b zend
git subtree split --prefix src/phpgo -b phpgo

cd $CURDIR


# 每次都会重新创建
git reset --hard 3d1b94e5cf4d878f776437c60e16a0ed97fd137a

if [ ! -d zend ] ; then
    git subtree add --prefix zend ../atapi/ zend
else
    git subtree pull --prefix zend ../atapi/ zend
fi
if [ ! -d phpgo ] ; then
    git subtree add --prefix phpgo ../atapi/ phpgo
else
    git subtree pull --prefix phpgo ../atapi/ phpgo
fi


# git filter-branch --force --commit-filter \
#    'if [ "$GIT_AUTHOR_EMAIL" = "whouare@where.com" ]; then \
# export GIT_AUTHOR_NAME="kitech";\
# export GIT_AUTHOR_EMAIL=$GIT_EMAIL;\
# export GIT_COMMITTER_NAME="kitech";\
# export GIT_COMMITTER_EMAIL=$GIT_EMAIL;\
# fi;\
# git commit-tree "$@"'

# done
