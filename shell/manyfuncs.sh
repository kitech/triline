#!/bin/sh

function gomanyfuncs() {
    gofile="manyfuncs.go"
    echo > $gofile
    echo "package manyfuncs" >> $gofile

    echo "//go:noinline" >> $gofile
    echo "func The_callee_deducer(fnidx uint32, typ byte, args ...interface{}) interface{}{return 789}" >> $gofile
    echo >> $gofile

    cnter=0
    while true; do
        cnter=$((cnter+1))
        if [[ $cnter -gt 1000 ]]; then
            break
        fi
        # echo $cnter

        echo "//go:noinline" >> $gofile
        echo "func A_long_func_name_maybe_very_long_$cnter() uint32 {" >> $gofile
        echo "  return The_callee_deducer($RANDOM, byte($RANDOM%256), 123, \"ggg\").(uint32)" >> $gofile
        echo "}" >> $gofile
    done
}

function gomanyfuncs2() {
    gofile="manyfuncs.go"
    echo > $gofile
    echo "package manyfuncs" >> $gofile
    echo "//go:noinline" >> $gofile
    echo "func The_callee_deducer(fnidx uint32, typ byte, args ...interface{}) interface{}{return 789}" >> $gofile
    echo "func mkfn(a1 int) func() uint32 {" >> $gofile
    echo "  return func () uint32 {" >> $gofile
    echo "  return the_callee_deducer($RANDOM, byte($RANDOM%256), 123, a1, \"ggg\").(uint32)" >> $gofile
    echo "}" >> $gofile
    echo "}" >> $gofile
    echo >> $gofile

    cnter=0
    while true; do
        cnter=$((cnter+1))
        if [[ $cnter -gt 100000 ]]; then
            break
        fi
        # echo $cnter

    	  #echo "//go:noinline" >> $gofile
        echo "var A_long_func_name_maybe_very_long_$cnter = mkfn(123)" >> $gofile
        #echo "  return the_callee_deducer($RANDOM, byte($RANDOM%256), 123, \"ggg\").(uint32)" >> $gofile
        #echo "}" >> $gofile
    done
}

function cmanyfuncs() {
    gofile="manyfuncs.c"
    echo > $gofile
    echo "void* the_callee_deducer(int fnidx, unsigned char typ, char* args, ...) {return (void*)789;}" >> $gofile
    echo >> $gofile

    cnter=0
    while true; do
        cnter=$((cnter+1))
        if [[ $cnter -gt 100000 ]]; then
            break
        fi
        # echo $cnter

        echo "int a_long_func_name_maybe_very_long_$cnter() {" >> $gofile
        echo "  return (int)(long)(the_callee_deducer($RANDOM, (unsigned char)($RANDOM%256),\"%d%s\", 123, \"ggg\"));" >> $gofile
        echo "}" >> $gofile
    done

    echo "int main(int argc, char**argv) {return 0;}" >> $gofile
}

gomanyfuncs;
#gomanyfuncs2;
#cmanyfuncs;

# go
# got file manyfuncs.go 13M
# build it used 3.1G RAM

# c
# got file manyfuncs.c 13M
# build it used 1.5G RAM

# manyfuncs2
# use closure to reduce symbol table size, and reduce compile RAM usage
