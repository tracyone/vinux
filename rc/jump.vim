" Package info {{{
" jump to somewhere:file,mru,bookmark
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky',{'on': 'CtrlPFunky'}
Plug 'fisadev/vim-ctrlp-cmdpalette',{'on': 'CtrlPCmdPalette'}
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'easymotion/vim-easymotion', { 'on': [ '<Plug>(easymotion-lineforward)',
            \ '<Plug>(easymotion-linebackward)','<Plug>(easymotion-overwin-w)' ]}
Plug 't9md/vim-choosewin'
Plug 'kshenoy/vim-signature'
Plug 'MattesGroeger/vim-bookmarks'
if exists('g:feat_enable_airline') && g:feat_enable_airline == 0
    Plug 'ap/vim-buftabline'
    let g:buftabline_numbers=2
    let g:buftabline_show=1
    let g:buftabline_indicators=1
endif
Plug 'ronakg/quickr-preview.vim'
autocmd filetype_group FileType qf nmap <buffer> j <down><plug>(quickr_preview)
autocmd filetype_group FileType qf nmap <buffer> k <up><plug>(quickr_preview)
" }}}
" Matchit.vim {{{
"extend %
runtime macros/matchit.vim "important 
let g:loaded_matchit=0
let b:match_ignorecase=1 
set mps+=<:>
set mps+=":"
"}}}
" Easymotion {{{
map W <Plug>(easymotion-lineforward)
map B <Plug>(easymotion-linebackward)
" MultiWindow easymotion for word
nmap <Leader>F <Plug>(easymotion-overwin-w)
" Multi Input Find Motion:s
nmap <Leader>es <Plug>(easymotion-sn)
" Multi Input Find Motion:t
nmap <Leader>et <Plug>(easymotion-tn)
" MultiWindow easymotion for line
nmap <Leader>el <Plug>(easymotion-overwin-line)
" MultiWindow easymotion for char
nmap <Leader>ef <Plug>(easymotion-overwin-f)

let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0
" }}}
" vim-bookmark {{{
let g:bookmark_auto_save = 1
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
let g:bookmark_auto_close = 1
"Bookmark annotate
nnoremap <leader>mi :BookmarkAnnotate<CR>
"Bookmark toggle
nnoremap <leader>ma :BookmarkToggle<cr>
"Bookmark annotate 
vnoremap <leader>mi :<c-u>exec ':BookmarkAnnotate '.getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>
"Bookmark clear
nnoremap <leader>mc :BookmarkClear<cr>
"Bookmark show all
nnoremap <leader>mb :BookmarkShowAll<CR>
" }}}
" Ctrlp {{{
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
" Misc {{{
let g:SignatureEnabledAtStartup=1
let g:choosewin_overlay_enable = 1
" Choose windows
nmap <Leader>wc <Plug>(choosewin)
" }}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
