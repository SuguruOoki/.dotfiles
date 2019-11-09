" --------------------------------------------------------------------
"  Shougo/deoplete.nvim
" --------------------------------------------------------------------

" Use neocomplete
let g:deoplete#enable_at_startup = 1

" Use smartcase
let g:deoplete#enable_smart_case = 1

" Start completion with 2 chars
let g:deoplete#auto_complete_start_length = 2

" Number of completion list
let g:deoplete#max_list = 30

if !exists('g:deoplete#keyword_patterns')
  let g:deoplete#keyword_patterns = {}
endif

" Ignore Japanese
let g:deoplete#keyword_patterns['default'] = '\h\w*'
