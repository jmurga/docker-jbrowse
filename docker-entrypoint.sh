#!/bin/bash

cd ${JBROWSE}

if [ -d "/data/" ];
then
    for f in /data/*.sh;
    do
        [ -f "$f" ] && . "$f"
    done
fi

mkdir -p ${JBROWSE_DATA}/json/

apachectl start
# nginx -g "daemon off;"
