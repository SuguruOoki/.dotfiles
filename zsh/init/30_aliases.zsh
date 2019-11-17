alias q='exit'
alias crontab='crontab -i'

case "${OSTYPE}" in
darwin*)
    alias ls='ls -G'
    ;;
*)
    alias ls='ls --color=auto'
    ;;
esac

alias lr='ls -R'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias rm='rm -v'
alias rr='rm -r'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias df='df -h'

alias zmv='noglob zmv -W'

if is_cygwin; then
    alias open='cygstart'
fi

if has 'tmux'; then
    alias tmux='tmux -2'
    alias tmls='tmux ls'
    alias tmat='tmux a -t'
    alias tmns='tmux new-session -s'
fi

if has 'vim'; then
    alias v='vim'
    alias vi='vim'
fi

if has 'nvim'; then
    alias n='nvim'
fi

if has 'git'; then
    alias ga='git add'
    alias gaa='git add -A'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gpu='git push'
    alias gs='git switch'
    alias gd='git diff'
fi

if has 'docker-compose'; then
    alias dcu='docker-compose up -d'
    alias dcp='docker-compose ps'
    alias dcr='docker-compose restart'
    alias dcl='docker-compose logs'
    alias dcrm='docker-compose rm'
fi

if has 'hub'; then
    alias hc='hub clone'
    alias hb='hub browse'
fi

if has 'vagrant'; then
    alias vup='vagrant up'
    alias vsh='vagrant ssh'
    alias vhl='vagrant halt'
    alias vre='vagrant reload'
fi

if has 'lxterminal'; then
    alias lxterminal='lxterminal --geometry=100x35'
fi

if [[ -e ${HOME}/.local_aliases ]]; then
    source ${HOME}/.local_aliases
fi

