#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if ! has "zsh"; then
    install zsh

    if [ "$?" -eq 1 ]; then
        exit 1
    fi

    log_pass "zsh: Installed zsh successfully"
else
    log_pass "zsh: Already installed"
fi

# Assign zsh as a login shell
if ! contains "${SHELL:-}" "zsh"; then
    zsh_path="$(which zsh)"

    if ! grep -xq "${zsh_path:=/bin/zsh}" /etc/shells; then
        log_fail "You should append '$zsh_path' to /etc/shells"
        return
    fi

    if [ -x "$zsh_path" ]; then
        if chsh -s "$zsh_path" "${USER:-root}"; then
            log_pass "Change shell to $zsh_path for ${USER:-root} successfully"
        else
            log_fail "Cannot set '$zsh_path' as \$SHELL"
            log_fail "Check with '$zsh_path' to be described in /etc/shells"
            return
        fi

        if [ ${EUID:-${UID}} = 0 ]; then
            if chsh -s "$zsh_path" && :; then
                log_pass "Change shell to $zsh_path for root successfully"
            fi
        fi
    else
        log_fail "invalid path: $zsh_path"
        return
    fi
fi

