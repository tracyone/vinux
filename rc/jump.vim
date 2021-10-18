" Package info {{{
" jump to somewhere:file,mru,bookmark
if g:fuzzysearcher_plugin_name.cur_val ==# 'leaderf' 
    execute 'source '.$VIMFILES.'/rc/leaderf.vim'
elseif g:fuzzysearcher_plugin_name.cur_val ==# 'denite.nvim'
    execute 'source '.$VIMFILES.'/rc/denite.vim'
elseif g:fuzzysearcher_plugin_name.cur_val ==# 'fzf'
    execute 'source '.$VIMFILES.'/rc/fzf.vim'
elseif g:fuzzysearcher_plugin_name.cur_val ==# 'vim-clap'
    execute 'source '.$VIMFILES.'/rc/vim-clap.vim'
endif

"fallback option
if g:fuzzysearcher_plugin_name.cur_val ==# 'ctrlp'
execute 'source '.$VIMFILES.'/rc/ctrlp.vim'
endif

Plug 'easymotion/vim-easymotion', { 'on': [ '<Plug>(easymotion-lineforward)',
            \ '<Plug>(easymotion-linebackward)','<Plug>(easymotion-overwin-w)' ]}
Plug 't9md/vim-choosewin',{'on': '<Plug>(choosewin)'}
Plug 'kshenoy/vim-signature'
Plug 'MattesGroeger/vim-bookmarks', { 'on': ['BookmarkShowAll', 'BookmarkToggle', 'BookmarkAnnotate']}
if get(g:,'feat_enable_airline') == 0
    Plug 'tracyone/vim-buftabline'
    let g:buftabline_numbers=2
    let g:buftabline_show=1
    let g:buftabline_indicators=1
    if te#env#IsDisplay()
        let g:buftabline_separators = 1
    else
        let g:buftabline_separators = 0
    endif
endif
" }}}
" Matchit.vim {{{
"extend %
runtime macros/matchit.vim "important 
let b:match_ignorecase=1 
set matchpairs+=<:>
set matchpairs+=":"
"}}}
" Easymotion {{{
map W <Plug>(easymotion-lineforward)
map B <Plug>(easymotion-linebackward)
" MultiWindow easymotion for word
nmap  <silent><Leader>jw <Plug>(easymotion-overwin-w)
xmap  <silent><Leader>jw <Plug>(easymotion-bd-w)
omap  <silent><Leader>jw <Plug>(easymotion-bd-w)
" Multi Input Find Motion:s
nmap  <silent><Leader>js <Plug>(easymotion-sn)
xmap  <silent><Leader>js <Plug>(easymotion-sn)
omap  <silent><Leader>js <Plug>(easymotion-sn)
" Multi Input Find Motion:t
nmap  <silent><Leader>jt <Plug>(easymotion-tn)
xmap  <silent><Leader>jt <Plug>(easymotion-tn)
omap  <silent><Leader>jt <Plug>(easymotion-tn)
" MultiWindow easymotion for line
nmap  <silent><Leader>jl <Plug>(easymotion-overwin-line)
xmap  <silent><Leader>jl <Plug>(easymotion-bd-jk)
omap  <silent><Leader>jl <Plug>(easymotion-bd-jk)
" MultiWindow easymotion for char
nmap  <silent><Leader>jj <Plug>(easymotion-overwin-f)
xmap  <silent><Leader>jj <Plug>(easymotion-bd-f)
omap  <silent><Leader>jj <Plug>(easymotion-bd-f)
map <LocalLeader><LocalLeader> <Plug>(easymotion-prefix)

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
nnoremap  <silent><leader>mi :BookmarkAnnotate<CR>
"Bookmark toggle
nnoremap  <silent><leader>ma :BookmarkToggle<cr>
"Bookmark annotate 
vnoremap  <silent><leader>mi :<c-u>exec ':BookmarkAnnotate '.getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>
"Bookmark clear
nnoremap  <silent><leader>mc :BookmarkClear<cr>
"Bookmark show all
nnoremap  <silent><leader>mb :BookmarkShowAll<CR>
" }}}
" Misc {{{
let g:SignatureEnabledAtStartup=1
let g:choosewin_overlay_enable = 1
" Choose windows
nmap  <silent><Leader>wc <Plug>(choosewin)
" }}}
