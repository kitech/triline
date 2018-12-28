#!/bin/sh

https_proxy=$DTPXY \
http_proxy=$DTPXY \
HTTPS_PROXY=$DTPXY \
HTTP_PROXY=$DTPXY \
exec "$@"

