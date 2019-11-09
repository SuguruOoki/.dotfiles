#!/bin/bash

. "$DOTPATH"/etc/lib/util.zsh

if [ -z "$DOTPATH" ]; then
	echo "$DOTPATH is not set" >&2
	exit 1
fi

for f in "$DOTPATH"/etc/init/"$(get_os)"/*.sh; do
	if [ -f "$f" ]; then
		log_info "$(e_arrow "$(basename "$f")")"
		bash "$f"
	else
		continue
	fi
done

