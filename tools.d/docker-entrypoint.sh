#!/bin/sh
set -x

eotk=$EOTK_HOME/eotk
project=reddit
template=reddit.tconf
actualised=reddit.conf
test -f $actualised && exit 1

$eotk configure $template && \
    $eotk start $project && \
    $eotk status $project && \
    /usr/bin/nginx-prometheus-exporter
