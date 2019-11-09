" --------------------------------------------------------------------
" Visual Settings
" --------------------------------------------------------------------

" display row number
set number

" display cursor line
set cursorline

" visible whitespace
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:%,eol:<

" display statusline
set laststatus=2
set statusline=%F%m%r%h%w%{fugitive#statusline()}%=[TYPE:%Y][FMT:%{&fileformat}][ENC:%{&fileencoding}][LINE:%l/%L]

" Enable syntax highlight
syntax enable

" Highlight search words
set hlsearch

" Scroll offset
set scrolloff=3

" highlight ideographic spaces
augroup highlightSpace
  autocmd!
  autocmd Colorscheme * hi IdeographicSpace term=underline ctermbg=DarkRed guibg=DarkRed
  autocmd VimEnter,WinEnter * match IdeographicSpace /　\|\s\+$/
augroup END

colorscheme tender

" Display cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" Transparent
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight SpecialKey ctermbg=NONE
highlight EndOfBuffer ctermbg=NONE
highlight LineNr ctermbg=NONE ctermfg=008

" Comment
highlight Comment ctermfg=79

" Selection
highlight Visual ctermbg=26

" vimdiff
highlight DiffAdd ctermfg=15 ctermbg=22
highlight DiffDelete ctermfg=52 ctermbg=52
highlight DiffChange ctermfg=15 ctermbg=17
highlight DiffText ctermfg=15 ctermbg=27

" StatusLine
highlight StatusLine ctermfg=15
