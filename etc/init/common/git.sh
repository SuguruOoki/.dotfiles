#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if ! has "git"; then
    install git

    if [ "$?" -eq 1 ]; then
        exit 1
    fi

    log_pass "git: Installed git successfully"
else
    log_pass "git: Already installed"
fi


