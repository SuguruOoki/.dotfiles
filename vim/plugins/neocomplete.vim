" --------------------------------------------------------------------
" Shougo/neocomplete.vim
" --------------------------------------------------------------------

" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase
let g:neocomplete#enable_smart_case = 1
" Start completion with 2 chars
let g:neocomplete#auto_completion_start_length = 2
" Not ignore underbars
let g:neocomplete#enable_underbar_completion = 1
" Number of completion list
let g:neocomplete#max_list = 30

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
" Ignore Japanese
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable omni completion.
augroup SetOmniCompletionSetting
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

