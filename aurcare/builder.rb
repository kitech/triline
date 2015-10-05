#!/usr/bin/env ruby

def mysystem(cmd)
    cmd = "set -x;" + cmd;
    return system(cmd);
end

def help()
    puts "builder.rb <package-name>";
end

pkgname = ARGV[0];

if pkgname == nil
    puts "supply package name.";
    exit;
end

puts pkgname;
ret = mysystem("yaourt -G -y #{pkgname}");
puts ret;
exit if !ret;

Dir.chdir(pkgname) do
    ret = mysystem("makepkg -c -f --skippgpcheck");
    puts ret;
    exit if !ret;
end

pkgpkg = 
ret = mysystem("cp -v #{pkgname}/#{pkgname}*.pkg.tar.xz .");
puts ret;
exit if !ret;

ret = mysystem("repo-add aurcare.db.tar.gz #{pkgname}*.pkg.tar.xz");
puts ret;
ret = mysystem("git add -v #{pkgname}*.pkg.tar.xz");

ret = mysystem("unlink aurcare.db");
ret = mysystem("cp aurcare.db.tar.gz aurcare.db");


