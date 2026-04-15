#!/bin/sh

set -eu

pipe=/tmp/wobpipe

while :; do
  rm -f "$pipe"
  mkfifo "$pipe"
  tail -f "$pipe" | wob || true
  sleep 1
done
