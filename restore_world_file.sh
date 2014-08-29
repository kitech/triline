#!/bin/bash

# 使用eix和emerge --noreplace xxx重新创建/var/lib/portage/*

# 被删除文件:
# localhost ~ # rm -rfv /var/lib/portage/*
# removed `/var/lib/portage/config'
# removed `/var/lib/portage/preserved_libs_registry'
# removed `/var/lib/portage/world'
# removed `/var/lib/portage/world_sets'

# 使用eix --world -C -c -l 列出world中的包.
# 使用emerge --noreplace xxx将包添加到world文件中.


WORLD_PKGS=`eix --world -C -c -l --only-names`
pcnt=0
for p in $WORLD_PKGS
do
    echo "add $p to world ..."
    # emerge --noreplace $p
    echo $p >> /var/lib/portage/world
    set pcnt=`expr $pcnt + 1`
done

echo "Total packages: $pcnt."
echo "Done."


