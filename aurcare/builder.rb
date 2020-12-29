#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# 自动化下载并编译aur包。
# usage:
#    builder.rb <refresh|package>
# must run in ~/aur/aurcare/

#Dir.glob("aurcare.db.*") { |f|  puts f}
#exit

def mysystem(cmd)
    cmd = "set -x;" + cmd;
    return system(cmd);
end

def mysystem234(cmd)
    cmd = "set -x;" + cmd;
    return system(cmd);
end

g4narg = "-p cnpub"
g4narg = ""

# 手动执行repo-add时，不会自动更新到.db结尾的库文件中，有时需要手工处理下。
def refresh_aurdb()
    g4narg = ""
    ret = mysystem("unlink aurcare.db");
    ret = mysystem("cp aurcare.db.tar.gz aurcare.db");
    ret = mysystem("git4netup #{g4narg} put aurcare.db")
    #ret = mysystem("git4netup #{g4narg} put aurcare.db.tar.gz.old")
    #ret = mysystem("rclone copy aurcare.db asytech0:aurcare/")
    #ret = mysystem("rclone copy aurcare.db.tar.gz asytech0:aurcare/")
    #ret = mysystem("rclone copy aurcare.db.tar.gz.old asytech0:aurcare/")
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
refresh_aurdb() or true and exit if pkgname == 'refresh'

ret = mysystem("yaourt -G -y --noconfirm aur/#{pkgname}");
# 关于yaourt的返回值，包不存在:1，包正常下载:1，包覆盖返回:130
# 不好判断哪种调用成功，哪种调用失败，判断目录吧
abort("can not get pkgbuild: #{pkgname}") if !Dir.exists?(pkgname)


Dir.chdir(pkgname) do
    ret = mysystem("makepkg -c -f --skippgpcheck --skipchecksums");
    exit if !ret;
end


PKGEXT=".pkg.tar.zst"

# 删除旧版本的包
#ret = mysystem("rclone delete --include 'aurcare/#{pkgname}*.pkg.tar.zst' asytech0:")
Dir.glob("#{pkgname}*.pkg.tar.zst").each{ |f|  ret = mysystem("git4netup #{g4narg} delete #{f}")}
ret = mysystem("rm -fv #{pkgname}*.pkg.tar.zst")

ret = mysystem("cp -v #{pkgname}/#{pkgname}*.pkg.tar.zst ./");
abort('move pkg error.') if !ret;
ret = mysystem("repo-add aurcare.db.tar.gz #{pkgname}*.pkg.tar.zst");
abort('repo add error.') if !ret;

#ret = mysystem("cp -v #{pkgname}/#{pkgname}*.pkg.tar.zst /archrepo/packages/");
#abort('move pkg error2.') if !ret;

#ret = mysystem("git add -v #{pkgname}*.pkg.tar.zst");
#abort('add to git error.') if !ret;
Dir.glob("#{pkgname}*.pkg.tar.zst").each{ |f| ret = mysystem("git4netup #{g4narg} put #{f}")}
#ret = mysystem("rclone copy #{pkgname}*.pkg.tar.zst asytech0:aurcare/")

refresh_aurdb();

# 打包失败的临时文件，手动决定如果处理，有可能要查找错误原因，有可能直接删除。
# 删除成功打包的临时文件。
ret = mysystem("rm -rf ./#{pkgname}")
abort('clean build dir error.') if !ret;
ret = mysystem("nvtake #{pkgname}")

