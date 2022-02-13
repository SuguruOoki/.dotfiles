
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
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
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"
export PATH="/opt/homebrew/opt/zip/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export GOPRIVATE="github/SuguruOoki/"

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
