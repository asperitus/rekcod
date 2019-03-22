#!/bin/bash
# set -x

[ -z "$HOST_USER" ] && echo "HOST_USER not set" && exit 1

#
HOST_HOME=/host

RCDATA=$HOST_HOME/.rekcod
mkdir -p $RCDATA
if [ -z "$(ls -A $RCDATA)" ]; then
    ssh-keygen -f $RCDATA/id_rsa -t rsa -b 4096 -C "rekcod@local.m3" -N ''
fi

if [ ! -d $HOST_HOME/.ssh ]; then
    mkdir $HOST_HOME/.ssh
    chmod 700 $HOST_HOME/.ssh
fi

AUTH=$HOST_HOME/.ssh/authorized_keys
if [ ! -f $AUTH ]; then
    touch $AUTH
    chmod 644 $AUTH
fi
grep -q "rekcod@local.m3" $AUTH; if [ $? -ne 0 ]; then
    cat $RCDATA/id_rsa.pub >> $AUTH
fi

exec ssh -q -o StrictHostKeyChecking=no -i $RCDATA/id_rsa ${HOST_USER}@host.docker.internal "$@"