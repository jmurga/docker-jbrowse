#!/bin/bash

cd ${JBROWSE}

if [ -d "/data/" ];
then
    for f in /data/*.sh;
    do
        [ -f "$f" ] && . "$f"
    done
fi

mkdir -p $JBROWSE_DATA/json/

nginx -g "daemon off;"
