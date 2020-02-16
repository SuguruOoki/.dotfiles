export EDITOR=vim

# rubyをrbenvのものに切り替える
export PATH=/usr/local/bin:$PATH

# pyenvさんに~/.pyenvではなく、/usr/loca/var/pyenvを使うようにお願いする
export PYENV_ROOT=/usr/local/var/pyenv

# pyenvさんに自動補完機能を提供してもらう
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# brew install したPHPのパス
export PATH="/usr/local/opt/php@7.3/bin:$PATH"

# Dockerのbuild kitを有効にするための環境変数
export DOCKER_BUILDKIT=1

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# コマンドを整えるためのコマンド
alias ali='alias-change'
alias alil='alias-local-change'
alias ch-bash='chsh -s /bin/bash'

# コマンド系
alias sshh='peco-sshconfig-ssh'
alias vcd="peco-vagrant-cd"
alias findcd="peco-find-cd"
alias gd="peco-git-cd"
alias ph="peco-select-history"
alias nkfg="nkf --guess"
alias ll="ls -l"
alias la="ls -a"
alias ad='cd $HOME/"$(cat ~/actives.txt | peco)"'
alias sou="source"
alias mvim="_peco_mdfind"
alias ctags="`brew --prefix`/bin/ctags"
alias server=' php -S localhost:9000'

# selemium 系コマンド
alias selenium-stop="ps aux | grep selenium-server-standalone | grep -v grep |awk {'print \$2'} |xargs kill -9"
alias selenium-up='java -jar selenium-server-standalone-3.4.0.jar &'

alias read_ssh_password='cat ~/zshfiles/.ssh_password.txt'

# vagrant 系のコマンド
alias vgs="vagrant global-status -a"
alias vpu="vagrant ssh -c ./phpunit.sh"

# docker 系コマンド
alias pcdd="peco-docker-cd"
alias pcd="peco-docker-compose-cd"
alias dc="docker-compose"
alias -g P='`docker ps | tail -n +2 | peco | cut -d" " -f1`'
alias docker-ssh='docker exec -it P bash'
alias ldup='docker-compose up -d nginx mysql phpmyadmin redis workspace'

# diffツールを環境によって使い分ける
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff'
else
  alias diff='diff'
fi

# HomeBrewの brew コマンドをラップして、
# brew install した時にbrew fileのコマンドが
# 動作するように変更
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

# PATHの設定
# export PATH=$PATH:/usr/local/mysql/bin
export PATH=$HOME/.nodebrew/current/bin:$PATH

if [ -f ~/.env ] ; then
  source ~/.env
fi

if [ -f ~/zshfiles/.zsh-local ] ; then
  source ~/zshfiles/.zsh-local;
fi


# 現在の方法ではbranch名がremote/~/~などと言ったブランチ名への対応ができていないため、
# まだ使用しない方が良い。
function git-checkout-remote() {
  local branch=`git branch -a | fzf`
  if [ -n "$branch" ]; then
    git checkout -b ${branch} origin/${branch}
  fi
}

# atomでdailyコマンドを打つと良い感じになるはず。
function daily() {
    local current_directory=`pwd`;
    local year=`date +%Y`;
    local month=`date +%m`;
    local day=`date +%d`;

    cd ~/daily-report;
    git pull origin master;

    if [ ! -e "~/daily-report/${year}" ]; then
         mkdir $year;
         chmod 755 $year;
    fi
    cd $year;

    if [ ! -e "~/daily-report/${year}/${month}" ]; then
         mkdir $month;
         chmod 755 $month;
    fi

    cd $month;
    if [ ! -e "~/daily-report/${year}/${month}/${day}.md" ]; then
         touch "${day}.md";
         chmod 755 "${day}.md";
    fi

    vim "${day}.md";
    git add -A;
    git commit -m "日報のアップロード ${year}-${month}-${day}";
    git push origin master;

    cd $current_directory;
}


function sgrep() {
    search_word=$1;
    target_file=$2;
    if [ -n "$search_word" -a -n "$target_file" ]; then
        LANG=ja_JP.sjis grep -n `echo $search_word | nkf -s` $target_file  | nkf -w
    else
        echo '引数が足りません';
    fi
}

function fvim() {
  vim $(fzf);
}

function fgvim() {
  vim $(git diff --name-only | fzf);
}

function peco-sshconfig-ssh() {
    local host=$(grep 'Host ' ~/.ssh/config | awk '{print $2}' | peco)
    if [ -n "$host" ]; then
        echo "ssh -F ~/.ssh/config $host"
        ssh -F ~/.ssh/config $host
    fi
}

function peco-find-cd() {
  local FILENAME="$1"
  local MAXDEPTH="${2:-5}"
  local BASE_DIR="${3:-`pwd`}"

  if [ -z "$FILENAME" ] ; then
    echo "Usage: peco-find-cd <FILENAME> [<MAXDEPTH> [<BASE_DIR>]]" >&2
    return 1
  fi

  local DIR=$(find ${BASE_DIR} -maxdepth ${MAXDEPTH} -name ${FILENAME} | peco | head -n 1)

  if [ -n "$DIR" ] ; then
    DIR=${DIR%/*}
    echo "pushd \"$DIR\""
    pushd "$DIR"
  fi
}

function peco-open()
{
    local var
    local file
    local command="open"
    if [ ! -t 0 ]; then
        var=$(cat -)
        file=$(echo -n $var | peco)
    else
        return 1
    fi

    if [ -n "$1" ]; then
        command="$1"
    fi
    if [ -e "$file" ]; then
        eval "$command $file"
    else
        echo "Could not open '$file'." >&2
        return 1
    fi
}

function peco-docker-cd() {
  peco-mdfind-cd "Dockerfile"
}

function peco-docker-compose-cd() {
  peco-mdfind-cd "docker-compose.yml";
 }

# function docker-ssh2() {
#   # docker exec -it P bash
#   alpine_flg=`docker ps | tail -n +2 | peco | cut -d" "  -f9`
#   if [ "`echo $alpine_flg | grep 'alpine'`" ]; then
#     echo "含まれる"
#   fi
# }
#

function peco-git-cd() {
  peco-find-cd '.git'
}

function alias-change() {
  local directory=`pwd`
  vim ~/.dotfiles/zsh/init/31_zsh-old-aliases.zsh;
  cd ~/.dotfiles;
  git add .;
  git commit;
  git push origin master;
  make install
  cd $directory;
}

function alias-local-change() {
  vim ~/.dotfiles/.zsh-local;
  source ~/.dotfiles/.zsh-local;
}

function peco-select-history() {
    BUFFER=$(\history 50 | \
                    sort -r -k 2 |\
                    uniq -1 | \
                    sort -r | \
                    awk '$1=$1' | \
                    cut -d" " -f 2- | \
                    peco --query "$LBUFFER")
    CURSOR=$BUFFER
}

_peco_mdfind() {
  vim "$(mdfind -onlyin . -name $@ | peco)"
}

# アプリオープン系
#alias ao="atom ./"
alias net='open -n -a "Google Chrome.app" --args --app="http://php.net/manual/ja/funcref.php"'
alias enote='open -n -a "Google Chrome.app" --args --app="https://www.evernote.com/Home.action?message=forgotPasswordAction.sent&login=true#n=900d5ae2-93c9-491c-8575-eaa08db14039&s=s626&ses=4&sh=2&sds=5&"'
alias myer='open -n -a "Google Chrome.app" --args --app="https://dev.mysql.com/doc/refman/5.6/ja/error-messages-server.html"'
alias checklist='open -n -a "Google Chrome.app" --args --app="https://qiita.com/SuguruOoki/private/65184ab64a8ae0cf9b86"'
alias vim-tips='open -n -a "Google Chrome.app" --args --app="https://qiita.com/SuguruOoki/private/65184ab64a8ae0cf9b86"'
alias 1on1='open -n -a "Google Chrome.app" --args --app="https://github.com/SuguruOoki/daily-report/wiki/1on1-%E3%81%BE%E3%81%A8%E3%82%81"'


# git系
alias gcb='git checkout -b'
alias gf='git fetch --all'
alias gcr='git-checkout-remote'
alias gme='git commit --amend --no-edit'
alias gul='git pull origin'
alias gsh='git push origin'
alias gst='git status'
alias gadd='git add .'
alias gf="git fetch --all"
alias glp='git log -p'
alias gun='git reset HEAD'
alias gaw="git diff -w --no-color | git apply --cached"
alias us="git checkout HEAD"
alias graph='git log --graph'
alias gds='git log --diff-filter=D --summary'
alias grj='cd $(git remind status -n | fzf)' # これはgit-remindがあることを前提としたコマンド。ない場合はbrewfileでinstallすること
alias gbd="git branch --merged|egrep -v '\*|develop|master'|xargs git branch -d"

# git系でpecoを使った選択系のコマンド
# alias gc=''
# alias gc='git checkout $(git branch | sed -e "/*/d" | peco)'
alias gdel='~/zshfiles/git_controller/git-pchk.sh'
alias gp='~/zshfiles/git_controller/git-padd.sh'
alias gsp='git stash list | peco | cut -d ":" -f 1 | git stash pop'
alias gcf='git diff --name-only | peco | xargs git checkout' # gitのファイルの差分を削除する
# alias gch = '!f() { git --no-pager reflog | awk '$3 == \"checkout:\" && /moving from/ {print $8}' | awk '!a[$0]++' | head | peco | xargs git checkout; }; f"

# vim系
alias cvim='vim ~/vimfiles/.vimrc'
alias sp='open -a "Sequel Pro.app"'
alias log="tailmainfunctionsystemlog"
alias veco='~/.vim/ctrlp-veco/bin/veco'

# alias cyclic = 'sh ~/zshfiles/cyclic_complexity.sh'
# ここまで個人で作成したコマンド

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
alias trans='trans -b en:ja'
alias transj='trans -b ja:en'

# .zshrcに以下追記
fpath=($HOME/.zsh/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init
fpath=($HOME/zshfiles/anyframe(N-/) $fpath)
autoload -Uz anyframe-init
anyframe-init

bindkey '^xb' anyframe-widget-cdr
bindkey '^x^b' anyframe-widget-checkout-git-branch

bindkey '^xr' anyframe-widget-execute-history
bindkey '^x^r' anyframe-widget-execute-history

bindkey '^xp' anyframe-widget-put-history
bindkey '^x^p' anyframe-widget-put-history

bindkey '^xg' anyframe-widget-cd-ghq-repository
bindkey '^x^g' anyframe-widget-cd-ghq-repository

bindkey '^xk' anyframe-widget-kill
bindkey '^x^k' anyframe-widget-kill

bindkey '^xi' anyframe-widget-insert-git-branch
bindkey '^x^i' anyframe-widget-insert-git-branch

bindkey '^xf' anyframe-widget-insert-filename
bindkey '^x^f' anyframe-widget-insert-filename

function peco-history-selection() {
    BUFFER=$(
        history -n 1 |
            awk '{printf ("%d %s\n",NR,$0)}'|
            sort -k1,1 -r -n |
            sed 's/^[^ ]* //' |
            peco )
    CURSOR=${#BUFFER}
    zle reset-prompt
}

if type peco > /dev/null
then
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
fi

# UTF-8
export LANG=ja_JP.UTF-8

# COREを作らない
ulimit -c 0

# Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
bindkey -e

# autoloadされる関数を検索するパス
fpath=(~/.zfunc $fpath)
fpath=(~/.git_completion $fpath)
fpath=(~/.zsh.d/anyframe(N-/) $fpath)

# zsh plugin
autoload -Uz anyframe-init
anyframe-init

# 履歴の保存先と保存数
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 色の設定
# local DEFAULT=$'%{^[[m%}'$
# local RED=$'%{^[[1;31m%}'$
# local GREEN=$'%{^[[1;32m%}'$
# local YELLOW=$'%{^[[1;33m%}'$
# local BLUE=$'%{^[[1;34m%}'$
# local PURPLE=$'%{^[[1;35m%}'$
# local LIGHT_BLUE=$'%{^[[1;36m%}'$
# local WHITE=$'%{^[[1;37m%}'$

# export LSCOLORS=exfxcxdxbxegedabagacad
# export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
autoload -U compinit; compinit -u

# 入力したコマンド名が間違っている場合には修正
setopt correct
setopt correct_all
# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
setopt auto_cd
# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
setopt auto_pushd
# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups
# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups
# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space
# 補完キー連打で順に補完候補を自動で補完
setopt auto_menu
# 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt extended_glob
# Beepを鳴らさない
setopt no_beep
setopt no_list_beep
# 補完候補を詰めて表示
setopt list_packed
# このオプションが有効な状態で、ある変数に絶対パスのディレクトリを設定すると、即座にその変数の名前が
# ディレクトリの名前になり、すぐにプロンプトに設定している'%~'やcdコマンドの'~'での補完に反映されるようになる。
setopt auto_name_dirs
# 補完実行時にスラッシュが末尾に付いたとき、必要に応じてスラッシュを除去する
setopt auto_remove_slash
# 行の末尾がバッククォートでも無視する
setopt sun_keyboard_hack
# 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt list_types
# 補完のときプロンプトの位置を変えない
setopt always_last_prompt
# 変数の単語分割を行う
setopt sh_word_split
# 履歴にタイムスタンプを追加する
setopt extended_history
# Ctrl-s, Ctrl-q によるフロー制御を無効にする
setopt no_flow_control
# 履歴を共有する
setopt share_history
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt notify

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1
# キャッシュを利用する
zstyle ':completion:*' use-cache true
# 補完から除外するファイル
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# 大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 履歴表示
#function __history() {
#  history -E 1
#}
#alias his=__history
alias his=anyframe-widget-execute-history

# ディレクトリスタックに直接移動する
#function __dirs() {
#  if [ -z $1 ]; then
#    dirs -v | perl -pe 's/\t/: /g'
#  else
#    dirs -v | perl -pe 's/\t/: /g' | grep $1
#  fi
#  echo -n "select number: "
#  read newdir
#  [ expr $newdir + 0 > /dev/null 2>&1 ]
#  cd +"$newdir"
#}
#alias cdd=__dirs
alias cdd=anyframe-widget-cdr
alias gs=gitswitch

function gitswitch() {
  local current_branch=$(git branch | grep \* | sed 's/ //g' | sed 's/*//g')
  local next_branch=$(git branch | sed -e "/*/d" | peco)
  git switch $next_branch
  if [ -e "composer.json" -a ${current_branch}!=${next_branch} ]; then
    echo 'composer, laravel cache clear execute...'
    composer dump-autoload && php artisan cache:clear && php artisan config:clear && php artisan view:clear && php artisan route:clear
    echo 'done'
  fi
}

# select history
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*'      recent-dirs-max 1000
  zstyle ':chpwd:*'      recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

# ブランチ名を表示する
function __git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\:\1/'
}
alias gbn=__git_branch

# Emacsはbrew版をターミナルで利用する
# alias emacs='/usr/local/Cellar/emacs/24.5/bin/emacs -nw'
alias gtags='/usr/local/Cellar/global/6.5.1/bin/gtags'
# alias screen='/usr/local/Cellar/screenutf8/4.3.1/bin/screen -U'

# 色の設定
if [ `uname` = "FreeBSD" ]; then
  alias ls='ls -GF'
  alias ll='ls -alGF'
elif [ `uname` = "Darwin" ]; then
  alias ls='ls -GF'
  alias ll='ls -alGF'
else
  alias ls='ls -F --color=auto'
  alias ll='ls -alF --color=auto'
fi

# プロンプト
setopt prompt_subst
if [ `whoami` = "root" ]; then
  PROMPT='[%F{red}%n@%m%F{default}]# '
else
  PROMPT='[%m$(gbn)]# '
fi
RPROMPT='[%F{green}%d%f%F{default}]'

# スクリーン起動
if [ "$WINDOW" = "" ] ; then
  screen
fi

function preexec() {
  if [ $TERM_PROGRAM = 'iTerm.app' ]; then
    mycmd=(${(s: :)${1}})
    echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):$mycmd[1]\e\\"
  fi
}
function precmd() {
  if [ $TERM_PROGRAM = 'iTerm.app' ]; then
    echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):idle\e\\"
  fi
}

peco-mdfind-cd() {
  local FILENAME="$1"

  if [ -z "$FILENAME" ] ; then
    echo "Usage: peco-find-cd <FILENAME>" >&2
    return 1
  fi

  local DIR=$(find ~ -maxdepth 5 -name ${FILENAME} | peco | head -n 1)

  if [ -n "$DIR" ] ; then
    DIR=${DIR%/*}
    echo "pushd \"$DIR\""
    pushd "$DIR"
  fi
}

zmodload zsh/terminfo zsh/system
# color_stderr() {
#   while sysread std_err_color; do
#     syswrite -o 2 "${fg_bold[red]}${std_err_color}${terminfo[sgr0]}"
#   done
# }
# exec 2> >(color_stderr)

# ファイルの読み込みを行うためのfunction
function loadlib() {
        lib=${1:?"You have to specify a library file"}
        if [ -f "$lib" ];then #ファイルの存在を確認
                . "$lib"
        fi
}

loadlib ~/zshfiles/.zsh-local
loadlib ~/zshfiles/gcloud.sh
loadlib ~/zshfiles/hard_controller/wifi_restart.sh

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced


# batchを止めるためにコメントアウトを追記するコマンド
function stopcron() {
  # tmuxでまとめてssh
  # /etc/rc.d/init.d/crond stop
  service crond stop;
  # ファイル名を変更することでファイルに書いてある全てのcronを止める方法
  # 引数を持たせてあげれば、これでファイル名を指定してあげるだけでなんとかなりそう。
  # sudo mv -i /etc/cron.d/{,.}$1
}

# ただコメントアウトを追記するコマンド
function add-comment-out() {
  local searchword=$1;
  sed "/$searchword/s/^/# /g" /work/test_1.txt
}

# phpのログの場所を取得するコマンド
function get_php_log_place() {
  php -i | grep error_log;
}

# 多段SSHを行うためのコマンド
# 第一引数: 踏み台サーバ
# 第二引数: ターゲットサーバ
# Passwordは発行した踏み台サーバのパスワードに置き換えて使用すること
# klistの部分は踏み台サーバにてパスワードを取得しているかコマンド
# kinitはパスワードの発行コマンドであるので、これをそれに当たるコマンド
# 環境によってはtarget_serverの書き方でawkのやり方がうまくいかない場合も想定される
function several_ssh() {
   # kinitのパスワードを書いておく
   local step_server=$1
   SSH_PASS=Password
   USER_NAME=$(whoami)
   expirate=$(ssh $step_server klist 2> /dev/null | wc -l | tr -d ' ')
   if [ $expirate = 0 ]; then
        # sleepを入れないと、チケットを取得する前にexpectが終わってしまう
        expect -c "
        spawn ssh $step_sever \"kinit\"
        expect \"Password\"
        send \"${SSH_PASS}\n\"
        spawn sleep 0.5s
        "
   fi
   target_server=$2
   if [ -z "$2" ]; then
       target_server=$(ssh $step_server "cat /etc/hosts" | awk -F'\t' '{printf $3"\n"}' | grep -v '^\s*$' | uniq | grep -v 'db\d$' | sort | peco | head -n 1 | sed -e "s/^\*\s*//g")
   fi
   if [ -n "$target_server" ]; then
        ssh -At $step_server ssh $target_server
   fi
}

# tmuxを使った同時操作によるリリースコマンド
# Apacheのログの場所を取得するコマンド
# nginxのログの場所を取得するコマンド
# phpのログの場所を取得するコマンド

function get_php_log_place() {
  php -i | grep error_log
  # もしno valueだったらエラー文を通知して終了
  # もしパスが存在した場合はそのパスの箇所をcutしてきてそれをechoする
}

# 上記ログから特定のエラーがないかを取得するコマンド
# 作りたいものを一瞬で開くためのコマンド
# 調査の時にgrepしたやつを全てそのままpbcopyして貼り付けられるやつ。
# 調査時に該当してgrepしたやつをうまい感じでスプレッドシートに貼ってくれるやつ
function ag_paste_to_spreadsheet() {
  ag -l $1;
  # spreadsheetに貼り付けるためにgoogleのライブラリを利用
}

# gg - git commit browser→git graphの略
# ブランチをグラフで綺麗に見るためのコマンド。
function gg() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {} FZF-EOF"
}

function revert_select() {
  local commit=`git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {} FZF-EOF"`
  echo commit
}


# fshowで選択した結果をくわせてコミットをrevertするコマンド
# 現状失敗した場合のrevertを高速で行うためのコマンドとなる
# また、masterで行うことを前提としているため、マージコミットを
# 扱うことを前提に設計している
function select-revert() {
  git log 
}

function cat-csv() {
  local file=`$1`
  sed 's/,,/, ,/g;s/,,/, ,/g' $file | column -s, -t
}

function cat-tsv() {
  local file=$1
  sed 's/               /       /g;s/            /         /g' $file | column -s, -t
}

function hanten() {
  local file=$1
  awk '
  { for (i=1; i<=NF; i++)  { a[NR,i] = $i } } NF>p { p = NF }
  END {
      for(j=1; j<=p; j++) { str=a[1,j]; for(i=2; i<=NR; i++){ str=str" "a[i,j]; }
        print str
      }
  }' $file | column -s, -t
}

function agx() {
   local search_word=$1
   local option=$2

   if [ -z "$2" ]; then
     option="--php"
   fi
   ag $1 $2 | tr "\t" "    " | awk '{sub(/:/,"\t"); print $0 }' | awk '{sub(/:/,"\t"); print $0 }' | pbcopy
}

function hwx() {
   local search_word=$1

   hw -i $1 | tr "\t" "    " | awk '{sub(/:/,"\t"); print $0 }' | awk '{sub(/:/,"\t"); print $0 }' | pbcopy
}

function gwx() {
   local search_word=$1
   git grep -p $1 | tr "\t" "    "  | sed '/function/d' | sed '/class/d' | sed '/\/\//d' |  sed '/\*/d' | awk '{sub(/:/,"\t"); print $0 }' | awk '{sub(/:/,"\t"); print $0 }' | pbcopy
}


# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word

# Wifiを接続するためのコマンドたち
# 過去に接続したことのあるwifiのリストを取得する
alias wifi_list='networksetup -listpreferredwirelessnetworks en0'
# wifiを接続するためのコマンドairportを有効にするエイリアス
# alias "airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
# SchemaSpyを使ってer図を作成する。
# 基本の引数をmysqlに合わせて作成するものとし、
# 他のことについては適宜作成するものとする。
# FIXME: 今の形ではDockerImageがない場合に、コマンドが失敗する。
# そのため、dotfilesの初期化の際にimageを入れる処理を加える必要がある。
# function make-er-from-db() {
#   local PWD=`pwd`
#   local 
#   docker run -v "$PWD/schema:/output" --net="host" schemaspy/schemaspy:snapshot \
#            -t <DB種類> -host <DBホスト名/IP>:<ポート> -db <DB名> -u <DBユーザー名> -p <DBパスワード>
# }

# redmineの操作をpecoって選ぶ
# 操作の選択はcase文
# それをfzfに食わせる
# 間の操作は全て踏み台サーバから叩く。

# 踏み台サーバーからredmineAPIを叩きにいく

# 該当のメソッドを持つファイルの一覧の中からさらにrequireしているファイルを探し出す。

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# gitで差分のあるファイルから一覧をとって実行するコマンド
# alias givim = 'git status | grep modified | awk -F\':\' \'{print $2}\' | sed -e "s/ //g" | fzf |vim'
alias gv=

function gitvim() {
   local file=$(git status | grep modified | awk '{print $2}' | peco)

   if [ -f $file ];then
     vim $file
   fi
}

# 調査用コマンドまとめ

alias du_folder_top_ten= 'du | sort -gr | head -10'
alias du_file_top_ten='ls -l | sort -k 5.5gr | head -10'

# githubにリポジトリを作成するコマンド
# パスワードについては、環境変数 GIT_HUB_PASSWORD を
# zsh-localで設定し、その設定が適用されている前提で、
# このコマンドを利用することとする。
function gcre() {
    local yourid   = "SuguruOoki"
    local yourpass = $GIT_HUB_PASSWORD
    git init && git add -A && git status;
    read -p "type repo name        : " name;
    read -p "type repo description : " description;

    # github
    curl -u ${yourid} https://api.github.com/user/repos -d '{"name":"'"${name}"'","description":"'"${description}"'","private":true}';
    git commit -m "first commit";
    git remote add origin https://github.com/${yourid}/${name}.git;
    git remote set-url origin git@github.com:${yourid}/${name}.git;
    git push --set-upstream origin master;
    # bitbucketならこうする。
    ## curl -X POST --user ${yourid}:${yourpass} https://api.bitbucket.org/2.0/repositories/${yourid}/${name} --data '{"is_private":true}'
}

function fetch() {
  local branch=`git branch | grep  \* | awk '{print $2}'`
  local stash_save='0'

  if [ git status | grep 'modified' ]; then
    echo "修正内容があるため、stashします"
    git stash
    $stash_save='1';
  fi

  if [ $branch != 'master' ]; then
    git checkout origin master
  fi

  git fetch --all

  if [ git status | grep 'nothing to commit' > /dev/null]; then
    echo "最新のcommitが内容なのでpullしません"
  else
    echo "最新のcommitが含まれるようなので、commitを取り込みます"

    git pull --rebase origin master
    git status
    git checkout origin $branch

    if [ $stash_save = '1']; then
      git stash pop
    fi
  fi

}

function docker-image-rm-peco() {
  local selected_image_id=`docker images | grep -v SIZE | peco | awk '{print $3}'`
  docker image rm $selected_image_id
}
alias dirp=docker-image-rm-peco

# 専門用語を取り出すためのコマンド。termextractのDockerコンテナが起動している前提のコマンド
alias termextract="docker run -v /var/lib/termextract:/var/lib/termextract \
  -a stdin -a stdout -a stderr -i naoa/termextract termextract_mecab.pl"

# history にコマンド実行時刻を記録する
HISTTIMEFORMAT='%Y-%m-%dT%T%z '
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# 
# ここからはLaravelのためのコマンド
#
function create-project() {
  project_name=$1
  composer create-project --prefer-dist laravel/laravel $project_name
}

###-tns-completion-start-###
if [ -f /Users/suguruohki/.tnsrc ]; then 
    source /Users/suguruohki/.tnsrc 
fi
###-tns-completion-end-###
export PATH=/usr/local/texlive/2019/bin/x86_64-darwin:$PATH
