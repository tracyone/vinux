" basic package
" Package info {{{
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
if !te#env#IsNvim() 
    if te#env#IsMac()
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
    elseif te#env#IsUnix()
        Plug 'Shougo/vimproc.vim', { 'do': 'make' }
    else
        Plug 'Shougo/vimproc.vim', { 'do': 'mingw32-make.exe -f make_mingw64.mak' }
    endif
    Plug 'Shougo/vimshell.vim',{'on':'VimShell'}
endif
Plug 'tracyone/love.vim'
Plug 'tracyone/mark.vim'
Plug 'itchyny/vim-cursorword'
Plug 'thinca/vim-quickrun',{'on': '<Plug>(quickrun)'}
if(!te#env#IsWindows())
    Plug 'vim-scripts/sudo.vim'
    if !te#env#IsNvim() 
        Plug 'lambdalisue/vim-manpager'
    endif
    if te#env#IsMac()
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote'}
    else
        Plug 'CodeFalling/fcitx-vim-osx'
    endif
endif

if te#env#IsVim8() || te#env#IsNvim()
    Plug 'neomake/neomake'
    Plug 'tracyone/neomake-multiprocess'
    "ag search c family function
    nnoremap <leader>vf :call neomakemp#global_search(expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]")<cr>
    "set grepprg=ag\ --nogroup\ --nocolor
    "set grepformat=%f:%l:%c%m
endif
"}}}
" Tagbar {{{
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
" Vimshell {{{
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

function! VimShellPop()
    let l:line=(38*&lines)/100
    if  l:line < 10 | let l:line = 10 |endif
    execute 'rightbelow '.l:line.'split'
    if te#env#IsNvim() | execute 'terminal' | else | execute 'VimShell' | endif
endfunction
noremap <F4> :call VimShellPop()<cr>
" Open vimshell or neovim's emulator
nnoremap <Leader>as :call VimShellPop()<cr>
"}}}
" Nerdtree {{{
let g:NERDTreeShowLineNumbers=0	"don't show line number
let g:NERDTreeWinPos='left'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let g:NERDTreeShowBookmarks=1
let g:NERDTreeChDirMode=2
noremap <F12> :NERDTreeToggle .<CR> 
" Open nerd tree
nnoremap <leader>te :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
inoremap <F12> <ESC> :NERDTreeToggle<CR>
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
"}}}
" Quickrun {{{
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
" Misc {{{
let g:love_support_option=['tabstop','shiftwidth','softtabstop'
            \,'expandtab','smarttab', 'termguicolors']
" Save basic setting
nnoremap <Leader>lo :Love<cr>
nnoremap <Leader>sc :Neomake<cr>
let g:neomake_open_list=2
" }}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
