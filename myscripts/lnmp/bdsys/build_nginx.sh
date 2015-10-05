#!/bin/sh

set -x

./configure --prefix=/serv/stow/nginx --with-debug --with-http_spdy_module --add-module=$HOME/workspace/nullimp/ngx_nullimp

#--add-module=$HOME/workspace/nullimp/ngx_nullimp
