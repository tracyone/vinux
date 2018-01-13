" Help:Welcome screen, leader guide
" Package info {{{
if v:version >= 704
    Plug 'hecal3/vim-leader-guide'
    nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
endif

Plug 'mhinz/vim-startify'
" }}}
" VimStartify {{{
if te#env#IsWindows()
    let g:startify_session_dir = $VIMFILES .'\sessions'
else
    let g:startify_session_dir = $VIMFILES .'/sessions'
endif
let g:startify_list_order = [
            \ 'commands',
            \ ['   These are my sessions:'],
            \ 'sessions',
            \ ['   My most recently used files in the current directory:'],
            \ 'dir',
            \ ['   My most recently used files:'],
            \ 'files',
            \ ]
let g:startify_change_to_dir = 1
let g:startify_files_number = 5 
let g:startify_change_to_vcs_root = 0
let g:startify_session_sort = 1
let g:startify_custom_header = []

let g:startify_commands = [
            \ {'o': [g:vinux_version, 'call te#utils#open_url("https://github.com/tracyone/vinux")']},
            \ {'v': ['Open vimrc', 'call feedkeys("\<Space>vc")']},
            \ ]

noremap <F8> :SSave<cr>
" Open startify windows
nnoremap <Leader>bh :Startify<cr>
autocmd misc_group FileType startify setlocal buftype=
" Session save 
nnoremap <Leader>ss :SSave<cr>
" Session load
nnoremap <Leader>sl :SLoad 
" Session delete
nnoremap <Leader>sd :SDelete<cr>
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
