#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# 自动化下载并编译aur包。
# usage:
#    builder.rb <refresh|package>

def mysystem(cmd)
    cmd = "set -x;" + cmd;
    return system(cmd);
end

def mysystem234(cmd)
    cmd = "set -x;" + cmd;
    return system(cmd);
end

# 手动执行repo-add时，不会自动更新到.db结尾的库文件中，有时需要手工处理下。
def refresh_aurdb()
    ret = mysystem("unlink aurcare.db");
    ret = mysystem("cp aurcare.db.tar.gz aurcare.db");
end

def help()
    puts "Usage:\n    builder.rb <package-name|refresh>";
end

pkgname = ARGV[0];

if pkgname == nil
    puts "supply package name.";
    help()
    exit;
end

# maybe
refresh_aurdb() and exit if pkgname == 'refresh'

ret = mysystem("yaourt -G -y aur/#{pkgname}");
# 关于yaourt的返回值，包不存在:1，包正常下载:1，包覆盖返回:130
# 不好判断哪种调用成功，哪种调用失败，判断目录吧
abort("can not get pkgbuild: #{pkgname}") if !Dir.exists?(pkgname)


Dir.chdir(pkgname) do
    ret = mysystem("makepkg -c -f --skippgpcheck --skipchecksums");
    exit if !ret;
end

# 删除老版本的包
ret = mysystem("rm -fv #{pkgname}*.pkg.tar.xz")

ret = mysystem("cp -v #{pkgname}/#{pkgname}*.pkg.tar.xz .");
abort('move pkg error.') if !ret;

ret = mysystem("repo-add aurcare.db.tar.gz #{pkgname}*.pkg.tar.xz");
abort('repo add error.') if !ret;
ret = mysystem("git add -v #{pkgname}*.pkg.tar.xz");
abort('add to git error.') if !ret;

refresh_aurdb();

# 打包失败的临时文件，手动决定如果处理，有可能要查找错误原因，有可能直接删除。
# 删除成功打包的临时文件。
mysystem("rm -rf ./#{pkgname}")
