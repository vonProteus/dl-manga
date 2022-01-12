#!/bin/bash -e

MANGAURL=$1
MANGADIR=$2

if [ ! -f "$CONFIG_FILE" ]; then
    echo "<config/>" > $CONFIG_FILE
fi

xml ed -L \
       -s "/config" -t elem -n "manga" \
       -s "/config/manga[last()]" -t elem -n "lastURL" -v "$MANGAURL" \
       -s "/config/manga[last()]" -t elem -n "date" -v "$(date -Iseconds)" \
       -s "/config/manga[last()]" -t elem -n "dir" -v "$MANGADIR" \
       $CONFIG_FILE

mkdir -p "$MANGADIR" 
pushd "$MANGADIR" 
dl-manga.sh "$MANGAURL"
