#!/usr/bin/env -S v

/*
Usage: mirswi [appname] [show|swi] [mirname]
*/

//
import flag
import vcp

fn sh(cmd string) {
	print(execute_or_exit(cmd).output)
}

// sh('ls')
vcp.info('hehhe')

archlinux_mirfile := '/etc/pacman.d/mirrorlist'
emacspkg_mirfile := '${vcp.homedir}/.spacemacs,${vcp.homedir}/.emacs'
nixpkg_mirfile := '${vcp.homedir}/.nix-channels'
pypip_mirfile := '${vcp.homedir}/.pip/pip.conf'
jsnpm_mirfile := ''
gopxy_mirfile := 'https://goproxy.cn,direct'

mirfiles := {
	'pacman':   archlinux_mirfile
	'emacspkg': emacspkg_mirfile
	'nixpkg':   nixpkg_mirfile
	'pypip':    pypip_mirfile
}
vcp.info(mirfiles.str())

cnmirhosts := ['mirrors.nju.edu.cn', 'mirrors.ustc.edu.cn', 'mirrors.sustech.edu.cn',
	'mirrors.sjtug.sjtu.edu.cn', 'mirrors.tuna.tsinghua.edu.cn']
