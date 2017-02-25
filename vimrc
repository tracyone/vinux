"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if te#env#IsWindows()
    let $HOME=$VIM
    let $VIMFILES = $VIM.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif

function! s:source_rc(path, ...) abort "{{{
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand($VIMFILES.'/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction"}}}

"{{{autocmd autogroup

augroup misc_group
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> q :q<cr>
augroup END

"automatic recognition vt file as verilog 
augroup filetype_group
    autocmd!
    au BufRead,BufNewFile *.vt setlocal filetype=verilog
    "automatic recognition bld file as javascript 
    au BufRead,BufNewFile *.bld setlocal filetype=javascript
    "automatic recognition xdc file as javascript
    au BufRead,BufNewFile *.xdc setlocal filetype=javascript
    au BufRead,BufNewFile *.mk setlocal filetype=make
    au BufRead,BufNewFile *.make setlocal filetype=make
    au BufRead,BufNewFile *.veo setlocal filetype=verilog
    au BufRead,BufNewFile * let $CurBufferDir=expand('%:p:h')
    au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} :setlocal filetype=markdown 
    au BufRead,BufNewFile *.hex,*.out,*.o,*.a Vinarise
    au BufEnter * 
                \ if &diff |
                \ set statusline=%!MyStatusLine(2) |
                \ endif
    autocmd FileType qf noremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR>
    " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
    autocmd FileType qf noremap <buffer> s <C-w><Enter><C-w>K
    autocmd FileType qf nnoremap <buffer> q :q<cr>
augroup END

"}}}

call s:source_rc('options.vim')
call s:source_rc('mappings.vim')

if filereadable($VIMFILES.'/.module.vim')
    :source $VIMFILES.'/.module.vim'
else
    let g:complete_plugin_type = 'ycm'
    let g:feat_enable_complete = 0
    let g:feat_enable_vim_develop = 0
    let g:feat_enable_ctrlp = 0
    let g:feat_enable_tmux = 0
    let g:feat_enable_git = 0
    let g:feat_enable_lang_c = 0
    let g:feat_enable_lang_verilog = 0
    let g:feat_enable_lang_markdown = 0
    let g:feat_enable_lang_vim = 0
    let g:feat_enable_awesome_gui = 0
    let g:feat_enable_tools = 0
    let g:feat_enable_edit = 0
endif

"Plugin setting{{{
" Vim-plug ------------------------{{{
let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#IsWindows()
        silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
call plug#begin($VIMFILES.'/bundle')

if g:feat_enable_complete == 1
    call s:source_rc('complete.vim')
endif

if g:feat_enable_ctrlp == 1
    call s:source_rc('ctrlp.vim')
endif

if g:feat_enable_lang_vim == 1
    call s:source_rc('vim.vim')
endif

if g:feat_enable_git == 1
    call s:source_rc('git.vim')
endif

if g:feat_enable_lang_markdown == 1
    call s:source_rc('markdown.vim')
endif

if g:feat_enable_lang_c == 1
    call s:source_rc('c.vim')
endif

if g:feat_enable_gui == 1
    call s:source_rc('gui.vim')
endif

if g:feat_enable_tools == 1
    call s:source_rc('tools.vim')
endif

Plug 'vim-scripts/verilog.vim',{'for': 'verilog'}
Plug 'thinca/vim-quickrun'
"some productive plugins
Plug 'vim-scripts/genutils'
if(!te#env#IsWindows())
    Plug 'vim-scripts/sudo.vim'
    if !te#env#IsNvim() | Plug 'vim-utils/vim-man' | endif
    if te#env#IsMac()
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote'}
    else
        Plug 'CodeFalling/fcitx-vim-osx'
    endif
endif
if !te#env#IsNvim() 
    if te#env#IsMac()
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
    elseif te#env#IsUnix()
        Plug 'Shougo/vimproc.vim', { 'do': 'make' }
    else
        Plug 'Shougo/vimproc.vim', { 'do': 'mingw32-make.exe -f make_mingw64.mak' }
    endif
    Plug 'Shougo/vimshell.vim',{'on':'VimShell'}
    Plug 'tracyone/YankRing.vim'
else
    Plug 'mattn/ctrlp-register',{'on': 'CtrlPRegister'}
endif
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kshenoy/vim-signature'
Plug 'majutsushi/tagbar'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   }
Plug 'vim-scripts/L9'
Plug 'mattn/emmet-vim',{'for': 'html'}
Plug 'tracyone/mark.vim'
Plug 'tracyone/love.vim'
Plug 't9md/vim-choosewin'
Plug 'itchyny/vim-cursorword'
if te#env#IsVim8() || te#env#IsNvim()
    Plug 'neomake/neomake'
    Plug 'tracyone/neomake-multiprocess'
endif
" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()
autocmd misc_group VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   echom '[t-vim]Need to install the missing plugins!'
            \|   PlugInstall --sync | q
            \| endif
"}}}

" Tohtml --------------------------{{{
let html_use_css=1
let g:user_emmet_leader_key = '<c-e>'
"}}}

" Tagbar --------------------------{{{
nnoremap <silent><F9> :TagbarToggle<CR>
" Open tagbar
nnoremap <leader>tt :TagbarToggle<CR>
let g:tagbar_left=0
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
"}}}

" Matchit.vim ---------------------{{{
"extend %
runtime macros/matchit.vim "important 
let loaded_matchit=0
let b:match_ignorecase=1 
set mps+=<:>
set mps+=":"
"}}}

" Nerdtree  -----------------------{{{
let NERDTreeShowLineNumbers=0	"don't show line number
let NERDTreeWinPos='left'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
noremap <F12> :NERDTreeToggle .<CR> 
" Open nerd tree
nnoremap <leader>te :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
inoremap <F12> <ESC> :NERDTreeToggle<CR>
"}}}

" DelimitMate ---------------------{{{
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 0
let delimitMate_expand_space = 0
"}}}

" yankring ------------------------{{{
if !te#env#IsNvim()
    nnoremap <c-y> :YRGetElem<CR>
    inoremap <c-y> <esc>:YRGetElem<CR>
    " Open yankring window
    nnoremap <Leader>yy :YRGetElem<CR>
else
    nnoremap <c-y> :CtrlPRegister<cr>
    inoremap <c-y> <esc>:CtrlPRegister<cr>
    " Open CtrlPRegister
    nnoremap <Leader>yy :CtrlPRegister<cr>
endif
let yankring_history_dir = $VIMFILES
let g:yankring_history_file = '.yank_history'
let g:yankring_default_menu_mode = 0
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
"}}}

" VimExplorer ---------------------{{{
let g:VEConf_systemEncoding = 'cp936'
noremap <F11> :silent! VE .<cr>
" Open Vim File Explorer
nnoremap <Leader>fj :silent! VE .<cr>
"}}}

" UltiSnips -----------------------{{{
if  te#env#SupportPy()
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsListSnippets ='<c-tab>'
let g:UltiSnipsJumpForwardTrigge='<c-j>'
let g:UltiSnipsJumpBackwardTrigge='<c-k>'
let g:UltiSnipsSnippetDirectories=['bundle/snippets']
let g:UltiSnipsSnippetsDir=$VIMFILES.'/bundle/snippets'
"}}}

" FencView ------------------------{{{
let g:fencview_autodetect=0 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
function! FencToggle()
    if &fenc ==# 'utf-8'
        FencManualEncoding cp936
        call te#utils#EchoWarning('Chang encode to cp936')
    elseif &fenc ==# 'cp936'
        FencManualEncoding utf-8
        call te#utils#EchoWarning('Chang encode to utf-8')
    else
        call te#utils#EchoWarning('Current file encoding is '.&fenc)
    endif
endfunction
" Convert file's encode
nnoremap <leader>tf :call FencToggle()<cr>
"}}}

" Renamer -------------------------{{{
noremap <F2> :Ren<cr>
"rename multi file name
nnoremap <Leader>fR :Ren<cr>
"}}}

" Vimshell ------------------------{{{
if(!te#env#IsNvim())
    let g:vimshell_user_prompt = '":: " . "(" . fnamemodify(getcwd(), ":~") . ")"'
    "let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_editor_command='gvim'
    if te#env#IsWindows()
        " Display user name on Windows.
        let g:vimshell_prompt = $USERNAME.'% '
    else
        " Display user name on Linux.
        let g:vimshell_prompt = $USER.'% '
    endif
    "let g:vimshell_popup_command='rightbelow 10split'
    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    silent! call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
    silent! call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
    augroup vimshell_group
        autocmd!
        au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head)
        au FileType vimshell :imap <buffer> <c-l> <Plug>(vimshell_clear)
        au FileType vimshell :imap <buffer> <c-p> <Plug>(vimshell_history_unite)
        au FileType vimshell :imap <buffer> <up> <Plug>(vimshell_history_unite)
        au FileType vimshell,neoman setlocal nonu nornu
        au FileType vimshell :imap <buffer> <c-d> <Plug>(vimshell_exit)
        au FileType vimshell :imap <buffer> <c-j> <Plug>(vimshell_enter)
        au Filetype vimshell  setlocal completefunc=vimshell#complete#omnifunc omnifunc=vimshell#complete#omnifunc
        autocmd FileType vimshell
                    \ call vimshell#altercmd#define('g', 'git')
                    \| call vimshell#altercmd#define('i', 'iexe')
                    \| call vimshell#altercmd#define('l', 'll')
                    \| call vimshell#altercmd#define('gtab', 'gvim --remote-tab')
                    \| call vimshell#altercmd#define('c', 'clear')
        "\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

        "function! g:my_chpwd(args, context)
        "call vimshell#execute('ls')
        "endfunction

        autocmd FileType int-* call s:interactive_settings()
    augroup END
    function! s:interactive_settings()
    endfunction
endif

function! TracyoneVimShellPop()
    let l:line=(38*&lines)/100
    if  l:line < 10 | let l:line = 10 |endif
    execute 'rightbelow '.l:line.'split'
    if te#env#IsNvim() | execute 'terminal' | else | execute 'VimShell' | endif
endfunction
noremap <F4> :call TracyoneVimShellPop()<cr>
" Open vimshell or neovim's emulator
nnoremap <Leader>as :call TracyoneVimShellPop()<cr>
"}}}

" Nerdcommander -------------------{{{
let g:NERDMenuMode=0
let NERD_c_alt_style=1
"}}}

" GlobalSearch --------------------{{{
"ag search c family function
nnoremap <leader>vf :call neomakemp#global_search(expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]")<cr>
"set grepprg=ag\ --nogroup\ --nocolor
"set grepformat=%f:%l:%c%m
autocmd misc_group FileType gitcommit,qfreplace setlocal nofoldenable
"}}}

" Vim-multiple-cursors ------------{{{
" }}}

" Easymotion ----------------------{{{
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

" Algin ---------------------------{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap <leader>al <Plug>(LiveEasyAlign)
" Live easy align
nmap <leader>al <Plug>(LiveEasyAlign)
if !exists('g:easy_align_delimiters')
    let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
" }}}

" Quickrun ------------------------{{{
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'message',
            \   },
            \}

let g:quickrun_no_default_key_mappings = 1
map <F6> <Plug>(quickrun)
vnoremap <F6> :'<,'>QuickRun<cr>
" run cunrrent file
nmap <leader>yr <Plug>(quickrun)
" run selection text
vnoremap <leader>yr :'<,'>QuickRun<cr>
" }}}

" Incsearch -----------------------{{{
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
" }}}

" syntax check -------------------{{{
let g:neomake_make_maker = {
            \ 'exe': 'make',
            \ 'args': ['-j8'],
            \ 'errorformat': '%f:%l:%c: %m',
            \ }
" }}}
" Misc ---------------------------{{{
command! -bang -nargs=* -complete=file Make Neomake! <args>

autocmd misc_group VimEnter * :let g:cursorword = 0

"remove mapping of * and # in mark.vim
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap <leader>mm <Plug>MarkSet
xmap <Leader>mm <Plug>MarkSet
nmap <leader>mr <Plug>MarkRegex
xmap <Leader>mr <Plug>MarkRegex
nmap <leader>mn <Plug>MarkClear
xmap <leader>mn <Plug>MarkClear
nmap <leader>m? <Plug>MarkSearchAnyPrev
nmap <leader>m/ <Plug>MarkSearchAnyNext


" realtime underline word toggle
nnoremap <leader>th :call te#utils#OptionToggle("g:cursorword",[0,1])<cr>
" YouDao translate
nnoremap <Leader>ay <esc>:Ydc<cr>
" YouDao translate (visual mode)
vnoremap <Leader>ay <esc>:Ydv<cr>
nnoremap <F10> <esc>:Ydc<cr>
vnoremap <F10> <esc>:Ydv<cr>
" vim calculator
nnoremap <Leader>ac :Crunch<cr>
" undo tree window toggle
nnoremap <leader>tu :UndotreeToggle<cr>
"hex to ascii convert
nnoremap <leader>ah :call Hex2asciiConvert()<cr>
" next buffer or tab
nnoremap <Leader>bn :bnext<cr>
" previous buffer or tab
nnoremap <Leader>bp :bprev<cr>
" delete buffer
nnoremap <Leader>bk :bdelete<cr>
" open current file's position with default file explorer
nmap <Leader>af gof
" open current file's position with default terminal
nmap <Leader>at got
" open project's(pwd) position with default file explorer
nmap <Leader>aF goF
" open project's(pwd) position with default terminal
nmap <Leader>aT goT
" save file
nnoremap <Leader>fs :call te#utils#SaveFiles()<cr>
" save all
nnoremap <Leader>fS :wa<cr>
" manpage or vimhelp on current curosr word
nnoremap <Leader>hm :call te#utils#find_mannel()<cr>
" open eval.txt
nnoremap <Leader>he :tabnew<cr>:h eval.txt<cr>:only<cr>
" open vim script help
nnoremap <Leader>hp :tabnew<cr>:h usr_41.txt<cr>:only<cr>
" open vim function list
nnoremap <Leader>hf :tabnew<cr>:h function-list<cr>:only<cr>

" quit all
nnoremap <Leader>qq :qa<cr>
" quit all without save
nnoremap <Leader>qQ :qa!<cr>
" save and quit all
nnoremap <Leader>qs :wqa<cr>
" open calendar
nnoremap <Leader>ad :Calendar<cr>
" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
" tab 1
nnoremap <leader>1 1gt
" tab 2
nnoremap <leader>2 2gt
" tab 3
nnoremap <leader>3 3gt
" tab 4
nnoremap <leader>4 4gt
" tab 5
nnoremap <leader>5 5gt
" tab 6
nnoremap <leader>6 6gt
" tab 7
nnoremap <leader>7 7gt
" tab 8
nnoremap <leader>8 8gt
" tab 9
nnoremap <leader>9 9gt
" toggle coding style 
nnoremap <leader>tc :call te#utils#coding_style_toggle()<cr>
function! DrawItToggle()
    let l:ret = te#utils#GetError('DrawIt','already on')
    if l:ret != 0
        :DIstop
    else
        call te#utils#EchoWarning('Started DrawIt')
    endif
endfunction
" draw it
nnoremap <leader>aw :call DrawItToggle()<cr>

let g:love_support_option=['tabstop','shiftwidth','softtabstop'
            \,'expandtab','smarttab', 'termguicolors']
let g:SignatureEnabledAtStartup=1
" toggle long or short statusline
nnoremap <leader>ts :call te#utils#OptionToggle('statusline',['%!MyStatusLine(1)','%!MyStatusLine(2)'])<cr>
" toggle paste option
nnoremap <leader>tp :call te#utils#OptionToggle("paste",[1,0])<cr>
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
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
" Toggle termguicolors
nnoremap <Leader>tl :call te#utils#OptionToggle('termguicolors',[1,0])<cr>

" }}}

" Windows manger -----------------{{{
" vertical open window
nnoremap <Leader>wv :vsp<cr>
" vertical open window then focus the new one
nnoremap <Leader>wV :vsp<cr><C-w>l
" horizontal open window 
nnoremap <Leader>ws :sp<cr>
" horizontal open window then focus the new one
nnoremap <Leader>wS :sp<cr><C-w>j
" maxsize of current windows
nnoremap <Leader>wm :only<cr>
" quit current windows
nnoremap <Leader>wd :q<cr>
" switch between two windows.
nnoremap <Leader>ww <C-w><C-w>
let g:choosewin_overlay_enable = 1
" Choose windows
nmap <Leader>wc <Plug>(choosewin)
" move to left win
nnoremap <Leader>wh <C-w>h
" move to right win
nnoremap <Leader>wl <C-w>l
" move down win
nnoremap <Leader>wj <C-w>j
" move up win
nnoremap <Leader>wk <C-w>k
" Session save 
nnoremap <Leader>ls :SSave<cr>
" Session load
nnoremap <Leader>ll :SLoad 
" Save basic setting
nnoremap <Leader>lo :Love<cr>
" }}}

filetype plugin indent on
syntax on
"}}}
"default is on but it is off when you are root,so we put it here
set modeline
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
