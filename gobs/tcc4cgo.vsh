#!/usr/bin/env -S v

import os
import vcp

// see ~/go
///

fn filter_args_sucks(args []string) []string{
    suckargs := {'-Qunused-arguments':1, '-Wl,--no-gc-sections':1}
    rets := []string{cap: args.len+8}
    rets << "-I"
    rets << '${@VEXEROOT}/thirdparty/tcc/lib/tcc/include'
    rets << "-L"
    rets << '${@VEXEROOT}/thirdparty/tcc/lib/tcc'
    for arg in args {
        if v := suckargs[arg] {
        }else{
            rets << arg
        }
    }
    return rets
}


fn filter_code_sucks(cfile string) {
    if !(cfile.ends_with('.c')||cfile.ends_with('.h'))  {
        return
    }
    lines := os.read_lines(cfile) or {panic(err)}
    if lines[0] == '// gosucks' {
        // return
    }
    news := []string{cap: lines.len*2}
    news << "// gosucks"
    news << '// ' + os.getwd()
    for idx, line in lines {
        if line.contains('Complex') {
            news << '//gosucks '+ line
        }else if line.starts_with('#pragma GCC') {
            news << '//gosucks '+ line
        } else if line.contains('__atomic_load_n') && !line.starts_with('#define') && ! lines[idx-1].starts_with('#define') && !line.starts_with('#undef') {
            news << '#define __atomic_load_n(x,y) *x'
            news << line
            news << '#undef __atomic_load_n'
        } else if line.contains('__atomic_store_n') && !line.starts_with('#define') && ! lines[idx-1].starts_with('#define') && !line.starts_with('#undef') {
            news << '#define __atomic_store_n(x,y,z) *x=y'
            news << line
            news << '#undef __atomic_store_n'
        }else if line.contains('__cgo_undefined__') {
            news << '// ' + line
        }else if line.contains('__cgo__1') {
            news << '// ' + line
        }else{
            news << line
        }
    }
    scc := news.join('\n')
    os.write_file(cfile, scc) or {panic(err)}
}

oldwd := os.getwd()
tccexe := '${@VEXEROOT}/thirdparty/tcc/tcc.exe'
logfile := '/tmp/golog'
tmpdir := '/tmp/gobtmps'
mkdir(tmpdir) or { if absfalse() {} }
if os.file_size(logfile) > 8*1024*1024 {
    os.truncate(logfile, 1*1024*1024) !
}
logfp := os.open_append(logfile) !
defer {logfp.close()}
logfn := fn[logfp](args ... Anyer) {
    // line := sprintax(...args)
    pid := os.getpid()
    ppid := os.getppid()
    line := sprintbx(...args)
    logfp.write_string('${ppid}:${pid}: '+line+'\n') or {panic(err)}
}

argstr := os.args.str()
// vcp.info(argstr)
// logfp.write_string(argstr)!
// logfp.write_string(sprinta(os.getwd(), '\n'))!
// logfn(argstr)
logfn('wd', os.getwd())

newargs := filter_args_sucks(os.args[1..])
cfile := newargs.last()
if os.base(cfile) == cfile {
    cfile = os.join_path(oldwd, cfile)
}
dstfile := os.join_path(tmpdir, os.base(cfile))
// backup file, why not exists?
if !newargs.last().starts_with('-'){
if true {
    files := os.ls(oldwd) !
    // logfn(cfile, dstfile, os.exists(cfile), files.str())
    os.cp(cfile, dstfile) or {panic('${err},${newargs}')}
 }
filter_code_sucks(cfile)
if os.base(cfile) == '_cgo_export.c' {
    hfile := cfile[..cfile.len-1]+'h'
    filter_code_sucks(hfile)
    os.cp(hfile, os.join_path(tmpdir, os.base(hfile))) !
}
}

infp := os.stdin()

isstdinfile := newargs.last()=='-' || newargs.join(' ').contains(' - ')
isstdinfile = false
stdinfile := ''
if isstdinfile {

    mut buf := []u8{len:0,cap:5}
    for i:=0;;i++ {
        logfn('reading', i.str(), stdinfile.len, isstdinfile, newargs.str(), infp.is_opened)
        if true {
            res := infp.read_bytes(5)
            logfn('readed', i.str(), res.len)
            if res.len > 0 {
                panic('wttt')
            }
            break
        }
        n := infp.read_bytes_with_newline(mut buf)!
        logfn('readed', i.str(), n)
        if n == 0 {
            break
        }
        stdinfile += buf[..n].bytestr()
    }
}

mut proc := os.Process{}
proc.filename = tccexe
proc.set_work_folder(oldwd)
proc.set_args(os.args[1..])
proc.set_args(newargs)
// proc.set_redirect_stdio()
proc.run()
proc.wait()
defer { proc.close() }
cres := ifelse(proc.code == 0, 'succ', 'fail') + ': '
logfn(cres, proc.status.str(), proc.code, proc.err, '/')// proc.str())
logfn(newargs.str())
// logfn(proc.stderr_read(), proc.stdout_read())
if proc.code != 0 {
    logfn('cd', oldwd, '&&', tccexe, newargs.join(' '), '|| cd -')
    if cfile.ends_with('.c') || cfile.ends_with('.s') {
        dstfile = os.join_path(tmpdir, os.base(cfile))
        os.cp(cfile, dstfile) or {
            logfn(err.str(), cfile, dstfile, os.exists(os.join_path(oldwd,cfile)))
        }
    }
}

filecc := ''
if ! newargs.last().starts_with('-') {
    filecc = os.read_file(cfile)!
}
logfn('isstdinfile', isstdinfile, stdinfile.len)
if filecc.contains('"completed"') {
// completed:1: error: '__cgo__2' undeclared
// if cfile.contains('cgo-gcc-inputfff-') {
    println("completed:1: error: '__cgo__2' undeclared")
    exit(3)
}else{
    exit(proc.code)
}

