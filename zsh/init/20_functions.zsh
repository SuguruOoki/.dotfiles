. "$DOTPATH"/etc/lib/util.zsh

dotfiles_download() {
    if [ -d "$DOTPATH" ]; then
        log_fail "$DOTPATH: already exists"
        exit 1
    fi

    e_newline
    e_header "Downloading dotfiles..."

    if has "git"; then
        git clone "$DOTFILES_GITHUB" "$DOTPATH"
    elif has "curl" || has "wget"; then
        tarball="https://github.com/s4kr4/dotfiles/archive/master.tar.gz"

        if has "curl"; then
            curl -L "$tarball"
        elif has "wget"; then
            wget -O - "$tarball"
        fi | tar xvz

        if [ ! -d dotfiles-master ]; then
            log_fail "dotfiles-master: not found"
            exit 1
        fi

        mv -f dotfiles-master "$DOTPATH"
    else
        log_fail "ERROR: require curl or wget"
        exit 1
    fi

    e_newline
    e_done "Download"
}

dotfiles_deploy() {
    e_newline
    e_header "Deploying dotfiles..."

    if [ ! -d $DOTPATH ]; then
        log_fail "$DOTPATH: not found"
        exit 1
    fi

    cd $DOTPATH

    make deploy &&
        e_newline && e_done "Deploy"
}

dotfiles_initialize() {
    if [ "$1" = "init" ]; then
        e_newline
        e_header "Initialize dotfiles..."

        if [ -f Makefile ]; then
            make init
        else
            log_fail "Makefile: not found"
            exit 1
        fi &&
            e_newline && e_done "Initialize"
    fi
}

dotfiles_install() {
    dotfiles_download &&
    dotfiles_deploy &&
    dotfiles_initialize "$@"
}

mkcd() {
    mkdir -p "$1"
    [ $? -eq 0 ] && cd "$1"
}

cmd_history() {
    if has fzy; then
        local tac
        if which tac > /dev/null; then
            tac="tac"
        else
            tac="tail -r"
        fi
        BUFFER=$(fc -l -n 1 | eval $tac | fzy)
        CURSOR=${#BUFFER}
    fi
}
zle -N cmd_history

fga() {
  modified_files=$(git status --short | awk '{print $2}') &&
  selected_files=$(echo "$modified_files" | fzf -m --preview 'git diff {}') &&
  git add $selected_files
}
