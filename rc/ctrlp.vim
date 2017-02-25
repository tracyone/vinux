Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky',{'on': 'CtrlPFunky'}
Plug 'fisadev/vim-ctrlp-cmdpalette',{'on': 'CtrlPCmdPalette'}
Plug 'FelikZ/ctrlp-py-matcher'

" Ctrlp ---------------------------{{{
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_files = 50000

" Tell Ctrl-P to keep the current VIM working directory when starting a
" search, another really stupid non default
let g:ctrlp_working_path_mode = 'w'

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
" Ctrl-P ignore target dirs so VIM doesn't have to! Yay!
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|svn|hg|build|sass-cache)$',
            \ 'file': '\v\.(exe|so|dll|o|d|proj|out)$',
            \ }
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'bookmarkdir']
if executable('ag')
    "NOTE: --ignore option use wildcard PATTERN instead of regex PATTERN,and
    "it does not support {}
    "--hidden:enable seach hidden dirs and files
    "-g <regex PATTERN>:search file name that match the PATTERN
    let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup 
                \ --ignore "*.[odODaA]"
                \ --ignore "*.exe"
                \ --ignore "*.out"
                \ --ignore "*.hex"
                \ --ignore "cscope*"
                \ --ignore "*.so"
                \ --ignore "*.dll"
                \ -g ""'
    let g:ctrlp_use_caching = 0
    let g:ctrlp_show_hidden = 1
    let g:user_command_async = 1
endif
let g:ctrlp_funky_syntax_highlight = 0
let g:ctrlp_funky_matchtype = 'path'
nnoremap <c-k> :CtrlPFunky<Cr>
nnoremap <c-j> :CtrlPBuffer<Cr>
" toggle ctrlp g:ctrlp_use_caching option
nnoremap <leader>tj :call te#utils#OptionToggle('g:ctrlp_use_caching',[0,1])<cr>
" show global mark
nnoremap <leader>pm :SignatureListGlobalMarks<Cr>
" ctrlp buffer 
nnoremap <Leader>pl :CtrlPBuffer<Cr>
nnoremap <c-l> :CtrlPMRUFiles<cr>
"CtrlP mru
nnoremap <Leader>pr :CtrlPMRUFiles<cr>
"CtrlP file
nnoremap <Leader>pp :CtrlP<cr>
" narrow the list down with a word under cursor
"CtrlP function 
nnoremap <Leader>pU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
"CtrlP cmd
nnoremap <Leader>pc :CtrlPCmdPalette<cr>
"CtrlP function
nnoremap <Leader>pk :CtrlPFunky<cr>
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
"}}}
