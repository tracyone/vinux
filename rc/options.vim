"Vim options setting

set timeout timeoutlen=1000 ttimeoutlen=100
"leader key
let g:mapleader="\<Space>"
let g:maplocalleader=','

set filetype=text
if te#env#IsWindows()
    set makeprg=mingw32-make
    let $MYVIMRC=$VIMFILES.'/vimrc'
else
    set keywordprg=""
    set path=.,/usr/include/,$PWD/**
    lan time en_US.UTF-8
    lan ctype en_US.UTF-8
endif

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb1830,big5,euc-jp,euc-kr,gbk
if v:lang=~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif
source $VIMRUNTIME/delmenu.vim
lan mes en_US.UTF-8
let $LANGUAGE='en_US.UTF-8'
"set langmenu=nl_NL.ISO_8859-1
scriptencoding utf-8

"list candidate word in statusline
set wildmenu
set wildmode=longest,full
set wildignore=*.swp,*.bak
set wildignore+=*.min.*,*.css.map
set wildignore+=*.jpg,*.png,*.gif
set wildignorecase
"set list  "display unprintable characters by set list
set listchars=tab:\|\ ,trail:-  "Strings to use in 'list' mode and for the |:list| command

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5
" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

"{{{backup
set backup "generate a backupfile when open file
set backupext=.bak  "backup file'a suffix
set backupdir=$VIMFILES/vimbackup  "backup file's directory
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
"}}}
"do not Ring the bell (beep or screen flash) for error messages
set noerrorbells
set matchtime=2  
set report=0  "Threshold for reporting number of lines changed
set helplang=en,cn  "set helplang=en

"stuck vim 7.3
if te#env#check_requirement()
    set autoread   "autoread when a file is changed from the outside
    set lazyredraw  " Don't update the display while executing macros
endif

set relativenumber number "show the line number for each line
set cmdheight=1  "number of lines used for the command-line
set showmatch "when inserting a bracket, briefly jump to its match
set smartcase  "override 'ignorecase' when pattern has upper case characters
set confirm  "start a dialog when a command fails
set smartindent "do clever autoindenting
"set nowrap   "don't auto linefeed
set showcmd "show (partial) command keys in the status line

"linux kernel coding stype
set tabstop=4  "number of spaces a <Tab> in the text stands for
set shiftwidth=4 "number of spaces used for each step of (auto)indent
set softtabstop=4  "if non-zero, number of spaces to insert for a <Tab>
set expandtab
set smarttab "a <Tab> in an indent inserts 'shiftwidth' spaces
set completeopt=preview,menuone
if has('patch-8.1.1902')
    set completeopt+=popup
    set completepopup=height:10,width:60,highlight:Pmenu,border:off
endif

set textwidth=160
set colorcolumn=161
set expandtab
set smarttab
let g:vinux_tabwidth=4
execute 'set tabstop='.g:vinux_tabwidth
execute 'set shiftwidth='.g:vinux_tabwidth
execute 'set softtabstop='.g:vinux_tabwidth

set hlsearch "highlight all matches for the last used search pattern
set noshowmode "display the current mode in the status line
"set ruler  "show cursor position below each window
set selection=inclusive  ""old", "inclusive" or "exclusive"; how selecting text behaves
set incsearch  "show match for partly typed search command
"set lbr "wrap long lines at a character in 'breakat'
set backspace=indent,eol,start  "specifies what <BS>, CTRL-W, etc. can do in Insert mode
set whichwrap=b,h,l,<,>,[,]  "list of menu_flags specifying which commands wrap to another line
set mouse=a "list of menu_flags for using the mouse,support all

"set autochdir  "change to directory of file in buffer
let s:seperator=' | '
let s:right_seperator = ' | '
if g:enable_powerline_fonts.cur_val ==# 'on'
    if get(g:, 'feat_enable_airline') == 1
        let s:seperator='  '
        let s:right_seperator = '  '
    endif
    let g:vinux_diagnostics_signs_error = ""
    let g:vinux_diagnostics_signs_warning = "⚠"
    let g:vinux_diagnostics_signs_info = ""
    let g:vinux_diagnostics_signs_hint = "💡"
else
    let g:vinux_diagnostics_signs_error = "x"
    let g:vinux_diagnostics_signs_warning = "w"
    let g:vinux_diagnostics_signs_info = "i"
    let g:vinux_diagnostics_signs_hint = "!"
endif

if get(g:,'feat_enable_basic') == 1
    if g:outline_plugin.cur_val == 'tagbar'
        let s:function_name="%{exists(':TagbarToggle')?\ tagbar#currenttag('%s".s:seperator."'".",'')\ :\ ''}"
    elseif g:outline_plugin.cur_val == 'vim-taglist'
        let s:function_name='%{Tlist_Get_Tagname_By_Line()}'.s:seperator
    elseif g:outline_plugin.cur_val == 'vista.vim'
        let s:function_name="%{get(b:, 'vista_nearest_method_or_function', '')}".s:seperator
    else
        let s:function_name=''
    endif
else
    let s:function_name=''
endif


if get(g:,'feat_enable_git') == 1
    if g:git_plugin_name.cur_val ==# 'gina.vim'
        let s:git_branch="%{exists('*gina#component#repo#branch')?\ gina#component#repo#branch()\ :\ ''}%= "
    else
        let s:git_branch="%{exists('*fugitive#statusline')?\ fugitive#statusline()\ :\ ''}%= "
    endif
else
    let s:git_branch='%= '
endif

"statuslne
if get(g:,'feat_enable_airline') != 1
    " Dictionary: take mode() input -> longer notation of current mode
    " mode() is defined by Vim
    let g:currentmode={ 'n' : 'N', 'no' : 'N-Operator Pending', 'v' : 'Visual', 'V' : 'VL', '^V' : 'VB', 's' : 'Select', 'S': 'S-Line', '^S' : 'S-Block', 'i' : 'I', 'R' : 'R', 'Rv' : 'V-R', 'c' : 'C', 'cv' : 'Vim Ex', 'ce' : 'Ex', 'r' : 'Prompt', 'rm' : 'More', 'r?' : 'Confirm', '!' : 'Shell', 't' : 'Term'}
    " Function: return current mode
    " abort -> function will abort soon as error detected
    function! ModeCurrent() abort
        let l:modecurrent = mode()
        " use get() -> fails safely, since ^V doesn't seem to register
        " 3rd arg is used when return of mode() == 0, which is case with ^V
        " thus, ^V fails -> returns 0 -> replaced with 'V Block'
        let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'VB '))
        let l:current_status_mode = l:modelist
        return l:current_status_mode
    endfunction
    function! MyStatusLine(type) abort
        let l:mystatus_line=' %{ModeCurrent()}'.s:right_seperator
        let l:mystatus_line.='%<%t%m%r%h%w'.s:right_seperator
        if winwidth(0) < 70
            return l:mystatus_line
        endif
        if te#env#SupportCscope()
            if cscope_connection() == 1
                let l:mystatus_line.="cs[1]".s:right_seperator
            endif
        endif
        let l:mystatus_line.=te#pg#get_tags_number(s:right_seperator)

        if get(g:, 'feat_enable_lsp') == 1
            let l:mystatus_line.=te#lsp#get_lsp_server_name(s:right_seperator)
        endif
        let l:mystatus_line.=s:git_branch
        if a:type == 1
            let l:mystatus_line.=s:function_name
        endif
        let l:mystatus_line.='%{&ft}'.s:seperator."%{(&fenc!=''?&fenc:&enc)}[%{&ff}]".s:seperator.'%p%%[%l,%v]'
        let l:mystatus_line.=s:seperator."%{strftime(\"%m/%d\-\%H:%M\")} "
        if get(g:, 'feat_enable_lsp') == 1
            let l:mystatus_line.=s:seperator.te#lsp#diagnostics_info('warning')
            let l:mystatus_line.=s:seperator.te#lsp#diagnostics_info('error')
        endif
        if exists('*neomakemp#run_status') && neomakemp#run_status() !=# ''
            let l:mystatus_line.=s:seperator.neomakemp#run_status().' '
        endif
        return l:mystatus_line
    endfunction
    if te#env#IsWindows()
        set statusline=%!MyStatusLine(3)
    else
        set statusline=%!MyStatusLine(1)
    endif
endif
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
set showtabline=1  "always show the tabline
set sessionoptions-=folds
set sessionoptions-=options
set fileformats=unix,dos,mac
set diffopt=vertical
set shortmess=filnxtToOI
"disable some builtin vim plugins
let g:loaded_logiPat           = 1
let g:loaded_rrhelper          = 1
let g:loaded_tarPlugin         = 1
let g:loaded_gzip              = 1
let g:loaded_zipPlugin         = 1
let g:loaded_2html_plugin      = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

 set viminfo='100,<20,s10,h
if te#env#IsNvim() != 0
    "Use floating window
    let g:plug_window=':call te#plug#window("")'
    " Use cursor shape feature
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

    "let g:python_host_prog  = '/usr/bin/python2'
    "let g:python3_host_prog = '/usr/bin/python3'

    if exists('&inccommand')
        set inccommand=nosplit
    endif

    if has('vim_starting')
        syntax off
    endif

    set fillchars+=msgsep:‾
    hi MsgSeparator ctermbg=black ctermfg=white
    set wildoptions+=pum
    set signcolumn=number
    if te#env#IsNvim() >= 0.9
        set diffopt+=linematch:60
        set laststatus=3
        set foldcolumn=auto:1
        v:lua.vim.loader.enable()
    endif
    if te#env#IsTmux()
        set clipboard+=unnamedplus
        let g:clipboard = {
                    \   'name': 'myClipboard',
                    \   'copy': {
                    \      '+': ['tmux', 'load-buffer', '-'],
                    \      '*': ['tmux', 'load-buffer', '-'],
                    \    },
                    \   'paste': {
                    \      '+': ['tmux', 'save-buffer', '-'],
                    \      '*': ['tmux', 'save-buffer', '-'],
                    \   },
                    \   'cache_enabled': 1,
                    \ }
    endif
else
    command! -nargs=? UpdateRemotePlugins call te#utils#EchoWarning("It is neovim's command")
    if te#env#IsVim() >= 900
        set wildoptions=pum,fuzzy
    endif
    set termencoding=utf-8
    set printfont=Yahei_Mono:h10:cGB2312  "name of the font to be used for :hardcopy
    "unnamed" to use the * register like unnamed register
    "autoselect" to always put selected text on the clipboardset clipboard+=unnamed
    set clipboard+=unnamed
    set guitablabel=%N\ %t  "do not show dir in tab
endif


if te#env#IsVim8()
    set belloff=all
    let g:t_number=v:t_number
    let g:t_string=v:t_string
    let g:t_func=v:t_func
    let g:t_list=v:t_list
    let g:t_dict=v:t_dict
    let g:t_float=v:t_float
    let g:t_bool=v:t_bool
    let g:t_none=v:t_none
    let g:t_job=v:t_job
    let g:t_channel=v:t_channel
    if te#env#SupportTerminal()
        if has('patch-8.0.1743')
            set termwinkey=<c-y>
        else
            set termkey=<c-y>
        endif
    endif
    if empty($TMUX)
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    else
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    endif
else
    let g:t_number=0
    let g:t_string=1
    let g:t_func=2
    let g:t_list=3
    let g:t_dict=4
    let g:t_float=5
    let g:t_bool=6
    let g:t_none=7
    let g:t_job=8
    let g:t_channel=9
endif

if has('patch-8.1.1600')
    set signcolumn=number
endif
if has('termguicolors')
    set termguicolors
endif

if te#env#SupportCscope()
    if get(g:,'tagging_program').cur_val ==# 'gtags'
        set cscopeprg=gtags-cscope
    else
        set cscopeprg=cscope
    endif
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set cscopetagorder=0
    set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
    " add any cscope database in current directory
    " else add the database pointed to by environment variable 
    set cscopetagorder=0
    set cscopeverbose 
    set cscoperelative
    " add cscope database at the first time
    call te#pg#add_cscope_out(getcwd())
    call te#pg#start_gen_cs_tags_threads()
endif

"{{{fold setting
"folding type: manual, indent, expr, marker or syntax
set foldenable                  " enable folding
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
function! MyFoldText() abort
    let line = getline(v:foldstart)
    let l:comment_content=''
    if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
        let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
        let linenum = v:foldstart + 1
        while linenum < v:foldend
            let line = getline( linenum )
            let l:comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
            if l:comment_content !=? ''
                break
            endif
            let linenum = linenum + 1
        endwhile
        let sub = initial . ' ' . l:comment_content
    else
        let sub = line
        let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
        if startbrace ==? '{'
            let line = getline(v:foldend)
            let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
            if endbrace ==? '}'
                let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
            endif
        endif
    endif
    let n = v:foldend - v:foldstart + 1
    let info = ' ' . n . ' lines'
    let sub = sub . '                                                                                                                  '
    let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    let fold_w = getwinvar( 0, '&foldcolumn' )
    let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
    return sub . info
endfunction
set foldtext=MyFoldText()
"}}}

