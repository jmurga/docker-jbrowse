#!/bin/bash
export JBROWSE_SAMPLE_DATA=/conda/opt/jbrowse/sample_data
export JBROWSE_DATA=/conda/opt/jbrowse/data
export JBROWSE=/conda/opt/jbrowse
export DATA_DIR=/data

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
