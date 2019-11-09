" --------------------------------------------------------------------
"  osyo-manga/vim-over
" --------------------------------------------------------------------

nnoremap <silent> <Space>o :OverCommandLine<CR>%s//g<Left><Left>
nnoremap <silent> <Space>O :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>

vnoremap <silent> <Space>o :OverCommandLine<CR>s//g<Left><Left>
