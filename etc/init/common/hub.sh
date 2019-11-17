#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if ! has "hub"; then
    if ! has "git"; then
        log_fail "ERROR: Require git"
        exit 1
    else
        case "$(get_os)" in
            osx)
                return
                ;;

            linux)
                install libevent-dev
                install libncurses5-dev
                install automake
                install pkg-config
                if [ "$?" -eq 1 ]; then
                    return
                fi
                ;;

            *)
                log_fail "ERROR: This script is only supported OSX or Linux"
                return
                ;;
        esac

        cdirectory=`pwd`
        git clone \
           --config transfer.fsckobjects=false \
           --config receive.fsckobjects=false \
           --config fetch.fsckobjects=false \
           https://github.com/github/hub.git ${HOME}/tmp/hub
        cd ${HOME}/tmp/hub
        sudo make install
        cd "$cdirectory"
    fi

    log_pass "hub: Installed hub successfully"
else
    log_pass "hub: Already installed"
fi

