#!/bin/sh

# 下载archlinux包的工程源文件PKGBUILD
# 官方版git仓库中的，非aur包。

pkgname=linux
pkgname=$1

if [ x"$pkgname" == x"" ] ; then
    echo "dlarchpkgsrc.sh <pkgname>"
    exit 1
fi

burl="https://projects.archlinux.org"
tree_url="$burl/svntogit/packages.git/tree/trunk?h=packages/${pkgname}"
echo "Get list files for $pkgname ..."
mkdir -p $pkgname
curl "$tree_url" > $pkgname/pkgsrc.tree.html
echo ""
echo ""

upaths=$(html2text $pkgname/pkgsrc.tree.html |grep "^\-rw"|awk -F\( '{print $4}'|awk -F\) '{print $1}')
# echo $files

cnter=0
for upath in $upaths ; do
    url="$burl$upath"
    # echo "$url"

    fname=$(echo $upath | awk -F/ '{print $6}' | awk -F? '{print $1}')
    # echo "fname: $fname"

    plain_url="$burl/svntogit/packages.git/plain/trunk/$fname?h=packages/$pkgname"
    echo "Get $fname ..."
    curl "$plain_url" > $pkgname/$fname
    cnter=$(expr $cnter + 1)
done

echo "===================================="
echo "Total got $cnter files for $pkgname."

if [ -f $pkgname/pkgsrc.tree.html ] ; then
    rm -f $pkgname/pkgsrc.tree.html
fi

