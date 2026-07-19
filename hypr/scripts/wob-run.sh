#!/bin/sh

set -eu

pipe=/tmp/wobpipe

rm -f "$pipe"
mkfifo "$pipe"

while :; do
  exec 3<> "$pipe"
  wob <&3 || true
  exec 3>&-
  sleep 1
done
