#!/bin/sh

set -x
DTPXY=127.0.0.1:8117
https_proxy=http://$DTPXY \
http_proxy=http://$DTPXY \
HTTPS_PROXY=http://$DTPXY \
HTTP_PROXY=http://$DTPXY \
exec "$@"

