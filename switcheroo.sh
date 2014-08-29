#!/bin/sh

# see: http://en.gentoo-wiki.com/wiki/Vga_switcheroo
# emerge hprofile

HPROF_GRAPH_DIR=/etc/hprofile/profiles/graphics
function install_switcheroo () {
    echo "Installing switcheroo..."

    mkdir -p $HPROF_GRAPH_DIR
    mkdir -p $HPROF_GRAPH_DIR/scripts
    mkdir -p $HPROF_GRAPH_DIR/files/etc/X11

    echo "intel" > $HPROF_GRAPH_DIR/profiles
    echo "radeon" >> $HPROF_GRAPH_DIR/profiles

    echo "intel" > $HPROF_GRAPH_DIR/default

    cp -va ./switcheroo_ptest $HPROF_GRAPH_DIR/ptest
    cp -va ./switcheroo_intel.start $HPROF_GRAPH_DIR/scripts/intel.start
    cp -va ./switcheroo_radeon.start $HPROF_GRAPH_DIR/scripts/radeon.start
    
    cp -va ./switcheroo_post-start $HPROF_GRAPH_DIR/post-start
    cp -va ./switcheroo_stop $HPROF_GRAPH_DIR/stop

    #note: suppose you have xorg.conf.intel and xorg.conf.radeon in /etc/X11
    cp -v /etc/X11/xorg.conf.intel $HPROF_GRAPH_DIR/files/etc/X11/
    cp -v /etc/X11/xorg.conf.radeon $HPROF_GRAPH_DIR/files/etc/X11/

    echo "Done"
}


function uninstall_switcheroo () {
    echo "Uninstalling switcheroo..."

    rm -vrf $HPROF_GRAPH_DIR/scripts/*
    rmdir $HPROF_GRAPH_DIR/scripts
    rm -vrf $HPROF_GRAPH_DIR/files/*
    rmdir $HPROF_GRAPH_DIR/files

    rm -vf $HPROF_GRAPH_DIR/*
    rmdir $HPROF_GRAPH_DIR

    echo "Done"
}


# usage:
# hprofile graphics.intel
# hprofile graphics.radeon

install_switcheroo;
# uninstall_switcheroo;

