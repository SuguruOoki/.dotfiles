" --------------------------------------------------------------------
"  Shougo/deoplete.nvim
" --------------------------------------------------------------------

let mapleader = "\<space>"
nnoremap <silent> <leader>e :<C-u>Denite file_rec -highlight-mode-insert=Search<CR>
nnoremap <silent> <leader>g :<C-u>Denite grep -auto-preview<CR>
nnoremap <silent> <leader>G :<C-u>DeniteCursorWord grep -auto-preview<CR>

call denite#custom#map('normal', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('normal', '<C-J>', '<denite:move_to_next_line>')
call denite#custom#map('insert', '<C-N>', '<denite:move_to_next_line>')
call denite#custom#map('insert', '<C-J>', '<denite:move_to_next_line>')
call denite#custom#map('normal', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('normal', '<C-K>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-P>', '<denite:move_to_previous_line>')
call denite#custom#map('insert', '<C-K>', '<denite:move_to_previous_line>')

call denite#custom#map('insert', '<C-S>', '<denite:do_action:split>')
call denite#custom#map('insert', '<C-V>', '<denite:do_action:vsplit>')

call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs', [
        \ '.git/',
        \ '.svn/',
        \ 'node_modules/',
        \ '*.log'
    \ ])

if executable('rg')
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
endif
