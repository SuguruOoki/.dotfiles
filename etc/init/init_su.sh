#!/bin/bash

. "$DOTPATH"/etc/lib/essential

if [ -z "$DOTPATH" ]; then
    echo "$DOTPATH is not set" >&2
    exit 1
fi

for f in "$DOTPATH"/.*; do

    if [ -f "$f" ];then
        basename=`basename "$f"`

        if [ ! -d .git ]; then
            continue
        fi

        sudo ln -sfnv $f /root/$basename
    fi

done

