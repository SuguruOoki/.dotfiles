#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

inclusion_dirs=(bin)
rc_files=(.vimrc .zshrc .zshenv .gitconfig)
config_dirs=(vim zsh)

log_info "Clean symbolic links"

for f in "$DOTPATH"/.*; do
    if [ -f "$f" ] || [ -d "$f" ]; then
        dotfile="${f##*/}"
        if [[ " ${rc_files[@]} " =~ " ${dotfile} " ]]; then
            log_echo "$HOME/${dotfile}"
            unlink "$HOME/${dotfile}"
        fi
    fi
done

for f in "$DOTPATH"/*; do
    if [ -d "$f" ]; then
        dir="${f##*/}"
        if [[ " ${inclusion_dirs[@]} " =~ " ${dir} " ]]; then
            log_echo "$HOME/${dir}"
            unlink "$HOME/${dir}"
        elif [[ " ${config_dirs[@]} " =~ " ${dir} " ]]; then
            log_echo "$XDG_CONFIG_HOME/${dir}"
            unlink "$XDG_CONFIG_HOME/${dir}"
        fi
    fi
done

echo
echo -n "Remove DOTFILES directory? (y/N)"
read

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    rm -rf "$DOTPATH"
fi

