
# go相关的包操作命令
# 使用：source /path/to/gocmd.sh
# 功能：封闭 python/gose.py的功能，让其成为shell功能

function gocd()
{
    pkgname=$1
    gose.py find "${pkgname}"
    true
}

function goins()
{
    pkgname=$1
    gose.py install "${pkgname}"
    true
}

# 本地查找
function gofind()
{
    pkgname=$1
    gose.py find "${pkgname}"
    true
}

# 网络搜索
function gose()
{
    pkgname=$1
    gose.py search "${pkgname}"
    true
}

# 删除本地的一个go包
function gorm()
{
    pkgname=$1
    gose.py search "${pkgname}"
    true
}
