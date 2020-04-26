#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

inclusion_dirs=(bin)
rc_files=(init.vim .zshrc .zshenv .gitconfig)
config_dirs=(neovim-dotfiles zsh)

XDG_CONFIG_HOME=$HOME/.config

if [ ! -d $XDG_CONFIG_HOME ]; then
    mkdir -p $XDG_CONFIG_HOME
fi

log_info "Make symbolic links"

for f in "$DOTPATH"/.*; do
    if [ -f "$f" ] || [ -d "$f" ]; then
        dotfile="${f##*/}"
        if [[ " ${rc_files[@]} " =~ " ${dotfile} " ]]; then
            log_echo ${dotfile}
            ln -sfnv "$f" "$HOME/$dotfile"
        fi
    fi
done

for f in "$DOTPATH"/*; do
    if [ -d "$f" ]; then
        dir="${f##*/}"
        if [[ " ${inclusion_dirs[@]} " =~ " ${dir} " ]]; then
            log_echo "${dir}"
            ln -sfnv "$f" "$HOME/${dir}"
        elif [[ " ${config_dirs[@]} " =~ " ${dir} " ]]; then
            log_echo ${dir}
            ln -sfnv "$f" "$XDG_CONFIG_HOME/${dir}"
        fi
    fi
done

if is_ssh_running; then
    ln -sfnv "$DOTPATH/.tmux.remote.conf" "$HOME/.tmux.conf"
else
    ln -sfnv "$DOTPATH/.tmux.conf" "$HOME/.tmux.conf"
fi
