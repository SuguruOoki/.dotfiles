# Change prompt depends on environments
color_red="%{[38;5;196m%}"
color_green="%{[38;5;046m%}"
color_blue="%{[38;5;045m%}"
color_orange="%{[38;5;202m%}"
color_gray="%{[38;5;242m%}"
color_end="%{[0m%}"

case ${UID} in
    # root
    0)
        PROMPT_USER="${color_red}%n${color_end}"
        ;;

    # other
    *)
        PROMPT_USER="${color_green}%n${color_end}"
        ;;

esac

if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    # remote connection
    PROMPT_PATH_COLOR="${color_orange}"
else
    # local
    PROMPT_PATH_COLOR="${color_blue}"
fi

PROMPT_PATH="%(5~,.../%3~,%~)"

PROMPT_STRING="${PROMPT_USER}@${PROMPT_PATH_COLOR}%m:${PROMPT_PATH}${color_end}"

function zle-line-init zle-keymap-select {
    case $KEYMAP in
        vicmd|visual)
            SUFFIX="|"
            ;;
        *)
            SUFFIX=">"
            ;;
    esac
    PROMPT=$'\n'"${PROMPT_STRING} ${SUFFIX} "
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# PROMPT=$'\n'"${PROMPT_STRING} > "
RPROMPT='${color_gray}''${vcs_info_msg_0_}'" %y [%D{%m/%d} %*]${color_end}"
PROMPT2="%_> "
