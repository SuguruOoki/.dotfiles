" --------------------------------------------------------------------
"  terryma/vim-multiple-cursors
" --------------------------------------------------------------------

function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
    echo 'Disabled Neocomplete'
  endif
endfunction

function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
    echo 'Disabled Neocomplete'
  endif
endfunction

