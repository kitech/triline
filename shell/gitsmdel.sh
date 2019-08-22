#!/bin/sh

# 删除submodule
# 1. 删除 .gitsubmodule中对应submodule的条目
# 2.删除 .git/config 中对应submodule的条目
# 3.执行 git rm --cached {submodule_path}。注意，路径不要加后面的“/”。例如：你的submodule保存在 supports/libs/websocket/ 目录。执行命令为： git rm --cached supports/libs/websocket
# 4. 删除`.git/modules/`目录下的对应内容

# 参数，是submodule的name，还是submodule的实际路径，这两个有什么关系
# 默认情况下，submodule的name 就是submodule的实际路径
# 如果另外指定名字，需要读取.gitmodules来确定路径名，好像没有什么命令。
# 所以就指定submodule的名字吧

# usage: gitsmdel.sh <submodule-name>
name=$1

if [ -z "$name" ]; then
    echo "gitsmdel.sh <submodule name>"
    # TODO show name list
    exit 1
fi

# $1: section name, string
# $2: ini config file path, .git/config or .gitmodule
function remove_section()
{
    secname=$1
    fname=$2
    if [ ! -e $fname ]; then
        echo "file not exists: $fname"
        return
    fi

    # echo "Removing $secname from $fname"
    tmpfile=/tmp/gitsmcfg
    touch "$tmpfile" # clean or create
    truncate  --size 0 "$tmpfile"
    found=
    while IFS= read -r line; do
        secbegin=$(echo "$line" | awk '{print $1}')
        # echo $secbegin
        if [ x"$secbegin" == x"[submodule" ]; then
            if [ -z "$found" ]; then
                secname=$(echo "$line" | awk '{print $2}' | awk -F\" '{print $2}')
                # echo "Enter new section: $secname"
                if [ x"$secname" == x"$name" ]; then
                    # echo "found it: $name"
                    found="true"
                fi
            else
                true
                found=
            fi
        fi
        if [ -z "$found" ]; then
            echo "$line" >> $tmpfile
        fi
    done < $fname

    sum1=$(md5sum $fname)
    sum2=$(md5sum $tmpfile)
    mv $tmpfile $fname
    # echo "Removed... $secname from $fname"
}

function git_submodule_delete()
{
    true;

    echo "Try remove submodule: $name (7 steps) ..."
    echo "1. finding ..."
    found=
    secname=
    path=
    url=
    deleted="not found"
    while IFS= read -r line ; do
        # echo "$line"
        secbegin=$(echo "$line" | awk '{print $1}')
        # echo $secbegin
        if [ x"$secbegin" == x"[submodule" ]; then
            if [ -z "$found" ]; then
                secname=$(echo "$line" | awk '{print $2}' | awk -F\" '{print $2}')
                # echo "Enter new section: $secname"
                if [ x"$secname" == x"$name" ]; then
                    # echo "found it: $name"
                    found="true"
                fi
            else
                true
                break # found it
            fi
        elif [ x"$secbegin" == x"path" ]; then
            path=$(echo "$line" | awk '{print $3}')
        elif [ x"$secbegin" == x"url" ]; then
            url=$(echo "$line" | awk '{print $3}')
        fi
    done < .gitmodules

    if [ ! -z "$found" ]; then
        # echo "Deleteing... $name, $path, $url"
        echo "  found $name $url"
        # echo
        echo "2. .gitmodules [$name] (submod section)"
        remove_section "$name" ".gitmodules"
        #echo
        echo "3. .git/config [$name] (config section)"
        remove_section "$name" ".git/config"
        # echo
        echo "4. ./$path (submod tree dir) ..."
        rm -rf "$path"

        dname=$(echo "$name" | awk -F/ '{print $1}')
        if [ x"$name" != x"$dname" ]; then
            echo "Smart modify to: $dname for .git/modules/$dname"
        fi
        echo "5. .git/modules/$dname (submod meta dir) ..."
        rm -rf ".git/modules/$dname"

        # echo
        echo "6. Prepare submit ...."
        # git status | head -n 16
        git status --porcelain -s | grep "^ "
        echo "7. Commit now ..."
        git commit -a -m "Remove submodule $name by gitsmdel.sh"
    else
        echo "  Not found submodule: $name"
        git submodule status
    fi
}

# delete current repo's submodule
git_submodule_delete

# 更新submodule的URL
# 1.更新 .gitsubmodule中对应submodule的条目URL
# 2.更新 .git/config 中对应submodule的条目的URL
# 3.执行 git submodule sync
