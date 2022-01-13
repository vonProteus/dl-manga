#!/bin/bash -e

MANGAURL=$1
MANGADIR=$2

if [ ! -f "$CONFIG_FILE" ]; then
    echo "<config/>" > $CONFIG_FILE
fi

xml ed -L \
       -s "/config" -t elem -n "manga" \
       -s "/config/manga[last()]" -t elem -n "lastURL" -v "$MANGAURL" \
       -i "/config/manga[last()]/lastURL" -t attr -n "new" -v "true" \
       -s "/config/manga[last()]" -t elem -n "date" -v "$(date -Iseconds)" \
       -s "/config/manga[last()]" -t elem -n "dir" -v "$MANGADIR" \
       $CONFIG_FILE
