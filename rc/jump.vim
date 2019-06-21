" Package info {{{
" jump to somewhere:file,mru,bookmark
if g:fuzzysearcher_plugin_name.cur_val ==# 'leaderf' && te#env#SupportAsync()
    Plug 'Yggdroot/LeaderF'
    Plug 'Yggdroot/LeaderF-marks',{'on': 'LeaderfMarks'}
    " show global mark
    nnoremap <leader>pm :LeaderfMarks<Cr>

    "function
    nnoremap <c-k> :LeaderfFunction<cr>
    nnoremap <Leader>pk :LeaderfFunction<cr>
    " buffer 
    nnoremap <Leader>pb :LeaderfBuffer<Cr>
    " recent file 
    nnoremap <c-l> :LeaderfMru<cr>
    nnoremap <Leader>pr :LeaderfMru<cr>
    "file
    nnoremap <Leader>pp :LeaderfFile<cr>
    "leaderf cmd
    nnoremap <Leader>ps :LeaderfSelf<cr>
    nnoremap <Leader>pt :LeaderfBufTag<cr>
    "colorsceme
    nnoremap <Leader>pc :LeaderfColorscheme<cr>
    nnoremap <Leader>ff :Leaderf dir<cr>
    nnoremap <Leader>fe :Leaderf feat -e<cr>
    nnoremap <Leader>fd :Leaderf feat<cr>
    "CtrlP cmd
    let g:Lf_ShortcutF = '<C-P>'
    let g:Lf_ShortcutB = '<C-j>'
    let g:Lf_CacheDiretory=$VIMFILES
    let g:Lf_DefaultMode='FullPath'
    let g:Lf_StlColorscheme = 'default'
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
    let g:Lf_UseMemoryCache = 0
    let g:Lf_ReverseOrder = 1
    nnoremap <Leader><Leader> :LeaderfFile<cr>
let g:Lf_Extensions = {
			\ 'dir': {
			\       'source': function('te#leaderf#dir#source'),
			\       'accept': function('te#leaderf#dir#accept'),
            \ 'need_exit': function('te#leaderf#dir#needExit'),
			\       'supports_name_only': 1,
			\       'supports_multi': 0,
			\ },
			\ 'feat': {
			\       'source': function('te#leaderf#feat#source'),
			\       'accept': function('te#leaderf#feat#accept'),
            \ 'arguments': [
            \  { 'name': ["-e"], 'nargs': 0, 'help': 'Enable'},
            \ ],
			\       'supports_name_only': 1,
			\       'supports_multi': 0,
			\ },
			\}
elseif g:fuzzysearcher_plugin_name.cur_val ==# 'denite.nvim' && te#env#SupportPy3() 
            \ && te#env#SupportAsync()
    Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'Shougo/neomru.vim'
    if g:fuzzy_matcher_type.cur_val ==# 'cpsm'
        Plug 'nixprime/cpsm', {'dir': g:vinux_plugin_dir.cur_val.'/cpsm_py3/',
                    \ 'do':'PY3=ON ./install.sh'}
    endif

    function! s:source_denite_vim()
        execute 'source '.$VIMFILES.'/rc/denite.vim'
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>source_denite_vim'))
    "keymapping for denite
    nnoremap <c-p> :Denite file/rec<cr>
    nnoremap <Leader><Leader> :Denite file/rec<cr>
    nnoremap <c-j> :Denite buffer<cr>
    nnoremap <c-l> :Denite file_mru<cr>
    nnoremap <c-k> :Denite outline<cr>
    nnoremap <Leader>pc :Denite colorscheme -post-action=open<cr>
    nnoremap <Leader>ff :Denite file<cr>
    "mru
    nnoremap <Leader>pr :Denite file_mru<cr>
    "file
    nnoremap <Leader>pp :Denite file/rec<cr>
    "function
    nnoremap <Leader>pp :Denite outline<cr>
    "vim help
    nnoremap <Leader>ph :Denite help<cr>
    "command history
    nnoremap <Leader>qc :Denite command_history<cr>
    "fly on grep
    nnoremap <Leader>pf :call denite#start([{'name': 'grep', 'args': ['', '', '!']}])<cr>
elseif g:fuzzysearcher_plugin_name.cur_val ==# 'fzf'
    execute 'source '.$VIMFILES.'/rc/fzf.vim'
else
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
endif
Plug 'ronakg/quickr-preview.vim', { 'for': ['qf']}
autocmd filetype_group FileType qf nmap <buffer> <down> <down><plug>(quickr_preview)
autocmd filetype_group FileType qf nmap <buffer> <up> <up><plug>(quickr_preview)
let g:quickr_preview_keymaps = 0
autocmd filetype_group FileType qf nmap <buffer> <Space><Space>  <plug>(quickr_preview)
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
nmap <Leader>jw <Plug>(easymotion-overwin-w)
xmap <Leader>jw <Plug>(easymotion-bd-w)
omap <Leader>jw <Plug>(easymotion-bd-w)
" Multi Input Find Motion:s
nmap <Leader>js <Plug>(easymotion-sn)
xmap <Leader>js <Plug>(easymotion-sn)
omap <Leader>js <Plug>(easymotion-sn)
" Multi Input Find Motion:t
nmap <Leader>jt <Plug>(easymotion-tn)
xmap <Leader>jt <Plug>(easymotion-tn)
omap <Leader>jt <Plug>(easymotion-tn)
" MultiWindow easymotion for line
nmap <Leader>jl <Plug>(easymotion-overwin-line)
xmap <Leader>jl <Plug>(easymotion-bd-jk)
omap <Leader>jl <Plug>(easymotion-bd-jk)
" MultiWindow easymotion for char
nmap <Leader>jj <Plug>(easymotion-overwin-f)
xmap <Leader>jj <Plug>(easymotion-bd-f)
omap <Leader>jj <Plug>(easymotion-bd-f)
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
" Misc {{{
let g:SignatureEnabledAtStartup=1
let g:choosewin_overlay_enable = 1
" Choose windows
nmap <Leader>wc <Plug>(choosewin)
" }}}
