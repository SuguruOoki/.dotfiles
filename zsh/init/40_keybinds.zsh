# --------------------------------------------------------------------
#  Key binds
# --------------------------------------------------------------------

bindkey -d
bindkey -v

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^N' down-line-or-history
bindkey '^P' up-line-or-history

bindkey -M viins '^B' backward-char
bindkey -M viins '^F' forward-char

bindkey '^R' cmd_history
