#!/bin/sh

# 下载archlinux包的工程源文件PKGBUILD
# 官方版git仓库中的，非aur包。
# TODO
#     aur4 support
#     detail error report

pkgname=linux
pkgname=$1

function help()
{
    echo "Usage:"
    echo "    [http_proxy=127.0.0.1:8117] dlarchpkgsrc.sh <pkgname>"
    echo ""
}
if [ x"$pkgname" == x"" ] ; then
    help;
    exit 1
fi

burl="https://projects.archlinux.org"
tree_url="$burl/svntogit/packages.git/tree/trunk?h=packages/${pkgname}"

# 支持proxy
proxy=""
if [ x"$http_proxy" != x"" ] ; then
    proxy="--proxy $http_proxy"
    echo "Using proxy setting: $proxy"
fi

# set -x
echo "Get list files for $pkgname ..."
mkdir -p $pkgname
curl $proxy "$tree_url" > $pkgname/pkgsrc.tree.html
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
    curl $proxy "$plain_url" > $pkgname/$fname
    cnter=$(expr $cnter + 1)
done

echo "===================================="
echo "Total got $cnter files for $pkgname."

if [ -f $pkgname/pkgsrc.tree.html ] ; then
    rm -f $pkgname/pkgsrc.tree.html
fi

