#!/bin/bash

function reload {
  cp -rf assets/* ../../public/plugin_assets/kanbine
}

if [ "$1" = "-r" ]; then
  for((;;)); do
    reload
    echo -n "..."
    sleep $2
    echo "!"
  done
else
  reload
fi
