if [ -z "${DOTPATH:-}" ]; then
    DOTPATH=~/.dotfiles; export DOTPATH
fi

if [ -z "${XDG_CONFIG_HOME:-}" ]; then
    XDG_CONFIG_HOME=~/.config; export XDG_CONFIG_HOME
fi

if [ -z "${XDG_CACHE_HOME:-}" ]; then
    XDG_CACHE_HOME=~/.cache; export XDG_CACHE_HOME
fi

# Load config files
for file in "${DOTPATH}"/zsh/init/*.zsh; do
    . "$file"
done

# Load zplug only in tmux
if [[ -n "$TMUX" ]]; then
    . "${XDG_CONFIG_HOME}"/zsh/zplug.zsh
fi

# if (which zprof > /dev/null); then
#   zprof | less
# fi

# Start TMUX
if has tmux; then
    tmuxx
fi

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/heroku-node/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
