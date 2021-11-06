"fallback to ctrlp
let g:fuzzysearcher_plugin_name.cur_val = 'ctrlp'

"{{{ Plugins
Plug 'ctrlpvim/ctrlp.vim',{'commit':'35c9b961c916e4370f97cb74a0ba57435a3dbc25'}
Plug 'tacahiroy/ctrlp-funky',{'on': 'CtrlPFunky'}
Plug 'fisadev/vim-ctrlp-cmdpalette',{'on': 'CtrlPCmdPalette'}
Plug 'zeero/vim-ctrlp-help',{'on': 'CtrlPHelp'}
"ctrlp thirdparty matchers
if te#env#SupportPy()
    if g:fuzzy_matcher_type.cur_val ==# 'cpsm' && v:version >= 704
        if te#env#SupportPy2()
            Plug 'nixprime/cpsm', {'do':'PY3=OFF ./install.sh'}
        else
            Plug 'nixprime/cpsm', {'dir': g:vinux_plugin_dir.cur_val.'/cpsm_py3/',
                        \ 'do':'PY3=ON ./install.sh'}
        endif
        let g:ctrlp_match_func ={'match': 'cpsm#CtrlPMatch'}
    else
        "fallback
        let g:fuzzy_matcher_type.cur_val='py-matcher'
        Plug 'FelikZ/ctrlp-py-matcher'
        let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    endif
endif
"}}}

"{{{ functions definition
function! s:update_ctrlp_command()
    if executable('rg')
        let g:ctrlp_user_command = 'rg '.g:ctrlp_search_hidden.' %s --files --color=never --glob "!.git"'
    elseif executable('ag')
        "NOTE: --ignore option use wildcard PATTERN instead of regex PATTERN,and
        "it does not support {}
        "--hidden:enable seach hidden dirs and files
        "-g <regex PATTERN>:search file name that match the PATTERN
        let g:ctrlp_user_command = 'ag '.g:ctrlp_search_hidden.' %s -l --nocolor --nogroup 
                    \ --ignore "*.[odODaA]"
                    \ --ignore "*.exe"
                    \ --ignore "*.out"
                    \ --ignore "*.hex"
                    \ --ignore "cscope*"
                    \ --ignore "*.so"
                    \ --ignore "*.dll"
                    \ --ignore ".git"
                    \ -g ""'
    else
        if te#env#IsUnix()
            let g:ctrlp_user_command = {
                        \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files -oc --exclude-standard'],
                        \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
                        \ },
                        \ 'fallback': 'find %s -type f'
                        \ }
        else
            let g:ctrlp_user_command = {
                        \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files -oc --exclude-standard'],
                        \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
                        \ },
                        \ 'fallback': 'dir %s /-n /b /s /a-d'
                        \ }
        endif
    endif
endfunction
"handle bug of gitgutter
function! s:ctrlp_funky()
    let g:gitgutter_async=0
    :CtrlPFunky
    let g:gitgutter_async=1
endfunction
"}}}

"{{{ Setting
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_files = 70000
let g:ctrlp_search_hidden=''

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

if g:ctrlp_caching_type.cur_val ==# 'limit'
    let g:ctrlp_use_caching = 50000
elseif g:ctrlp_caching_type.cur_val ==# 'off'
    let g:ctrlp_use_caching = 0
else
    let g:ctrlp_use_caching = 1
endif
call s:update_ctrlp_command()
let g:user_command_async = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_funky_syntax_highlight = 0
let g:ctrlp_funky_matchtype = 'path'
"}}}

"{{{ keymapping

nnoremap  <silent><c-k> :call <SID>ctrlp_funky()<cr>
nnoremap  <silent><c-j> :CtrlPBuffer<Cr>
nnoremap  <silent><leader>ti :call te#utils#OptionToggle('g:ctrlp_search_hidden',["", "--hidden"])<cr>:call <SID>update_ctrlp_command()<cr>
" show global mark
nnoremap  <silent><leader>pm :SignatureListGlobalMarks<Cr>
" ctrlp buffer 
nnoremap  <silent><Leader>pb :CtrlPBuffer<Cr>
nnoremap  <silent><c-l> :CtrlPMRUFiles<cr>
"CtrlP mru
nnoremap  <silent><Leader>pm :CtrlPMRUFiles<cr>
"CtrlP file
nnoremap  <silent><Leader>pp :CtrlP<cr>
" narrow the list down with a word under cursor
"CtrlP function 
nnoremap  <silent><Leader>pU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
"CtrlP colorsceme
nnoremap  <silent><Leader>pc :call te#ctrlp#colorscheme#start()<cr>
"CtrlP function
nnoremap  <silent><Leader>pk :CtrlPFunky<cr>
"CtrlP cmd
nnoremap  <silent><Leader><Leader> :CtrlP<cr>
"spacemacs :SPC ff
nnoremap  <silent><Leader>ff :call te#ctrlp#dir#start()<cr>
"CtrlP git branch
nnoremap  <silent><Leader>pgb :call te#ctrlp#git#start(1)<cr>
"CtrlP git show diff of specified commit
nnoremap  <silent><Leader>pgl :call te#ctrlp#git#start(2)<cr>
"CtrlP git log checkout
nnoremap  <silent><Leader>pgc :call te#ctrlp#git#start(3)<cr>
"CtrlP git remote branch
nnoremap  <silent><Leader>pgr :call te#ctrlp#git#start(4)<cr>
"vim help
nnoremap  <silent><Leader>ph :CtrlPHelp<cr>
nnoremap  <silent><Leader>fe :call te#ctrlp#feat#start(1)<cr>
nnoremap  <silent><Leader>fd :call te#ctrlp#feat#start(0)<cr>
nnoremap <silent><Leader>pr :call te#ctrlp#reg#start(0)<cr> 
inoremap <c-r> <c-o>:stopinsert<cr>:call te#ctrlp#reg#start(0)<cr> 
xnoremap <silent><Leader>pr :call te#ctrlp#reg#start(1)<cr> 

nnoremap  <silent><Leader>qc :call te#ctrlp#history#start(':')<cr>
nnoremap  <silent><Leader>q/ :call te#ctrlp#history#start('/')<cr>
"}}}
