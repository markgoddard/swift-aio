#!/bin/bash

set -ex

which aria2c || sudo apt -y install aria2

LOG_LEVEL=info

rm -rf downloaded-dir aria2c.log

aria2c \
  --log aria2c.log \
  --log-level $LOG_LEVEL \
  --console-log-level=warn \
  --check-certificate=false \
  --file-allocation=none \
  --allow-overwrite=true \
  --disable-ipv6=true \
  --seed-ratio=0.0 \
  --bt-tracker-interval=2 \
  --enable-dht=true \
  --enable-dht6=false \
  --enable-peer-exchange=true \
  --bt-enable-lpd=true \
  --follow-torrent=mem \
  --bt-tracker-connect-timeout=2 \
  --bt-tracker-timeout=5 \
  --seed-time=0 \
  --dir=downloaded-dir \
  $1
