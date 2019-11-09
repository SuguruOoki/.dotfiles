let $XDG_VIM_HOME = $HOME.'/.config/vim'

set runtimepath+=$XDG_VIM_HOME
set runtimepath+=$XDG_VIM_HOME/after

if executable('pyenv')
    let g:python3_host_prog  = $PYENV_ROOT . '/shims/python3'
endif

runtime! init/*.vim
runtime! functions.vim
