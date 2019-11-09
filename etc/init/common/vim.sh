#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if [[ -z "$(vim --version | head -n 1 | grep 8.0)" ]]; then
    if ! has "git"; then
        log_fail "ERROR: Require git"
        return
    else
        case "$(get_os)" in
            linux)
                if is_ubuntu; then
                    install lua5.2 lua5.2-dev luajit \
                        python-dev \
                        python3-dev \
                        ncurses-dev
                elif is_centos; then
                    install lua lua-devel luajit \
                        python-devel \
                        python3-devel \
                        ncurses-devel
                fi
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

        cd $(dirname $(which vim))
        sudo mv vim vim_old
        git clone https://github.com/vim/vim /tmp/vim
        cd /tmp/vim
        ./configure --with-features=huge --enable-multibyte --enable-fontset --enable-cscope --enable-fail-if-missing --enable-gpm --enable-luainterp=dynamic --enable-pythoninterp=dynamic --enable-python3interp=dynamic --prefix=/usr/local
        sudo make install

        cd "$cdirectory"
    fi

    log_pass "vim: Installed vim successfully"
else
    log_pass "vim: Already installed"
fi
