#!/bin/sh

set -eu

pipe="${XDG_RUNTIME_DIR:?}/wobpipe"

rm -f "$pipe"
mkfifo "$pipe"

while :; do
  exec 3<> "$pipe"
  wob <&3 || true
  exec 3>&-
  sleep 1
done
