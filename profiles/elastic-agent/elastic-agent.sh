#!/usr/bin/env bash

set -x
if [ ! -e "$file" ]; then
  echo "copy our preset config"
  cp /tmp/config.xml /godata/config/cruise-config.xml
  chown go:go /godata/config/cruise-config.xml
else
  echo "not reimporting example config, since it could have changed by now"
fi
