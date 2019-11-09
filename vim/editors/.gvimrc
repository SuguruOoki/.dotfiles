" --------------------------------------------------------------------
"  .vimrc for GVim
" --------------------------------------------------------------------

if has("mac")
	set transparency=15
elseif has("win64") || has("win32unix") || has("win32")
	autocmd GUIEnter * set transparency=230
endif

set columns=110
set lines=35


" --------------------------------------------------------------------
"  Fix Colorscheme
" --------------------------------------------------------------------

syntax enable
colorscheme tender

" Display cursorline
highlight CursorLine gui=underline guifg=NONE guibg=NONE

" Transparent
highlight LineNr guibg=NONE guifg=#777777

" Comment
highlight Comment guifg=#5fd7af

" Selection
highlight Visual guibg=#005fd7

" vimdiff
highlight DiffAdd guifg=#ffffff guibg=#005f00
highlight DiffDelete guifg=#5f0000 guibg=#5f0000
highlight DiffChange guifg=#ffffff guibg=#00005f
highlight DiffText guifg=#ffffff guibg=#005fff

" StatusLine
highlight StatusLine guifg=#ffffff

set guifont=Ricty:h10:cSHIFTJIS:qDRAFT,Migu_1M:h10:cSHIFTJIS:qDRAFT

" --------------------------------------------------------------------
"  Hide UI parts
" --------------------------------------------------------------------

" Invalidate toolbar
set guioptions-=T

" Invalidate menu bar
set guioptions-=m

" Invalidate scroll bars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b
