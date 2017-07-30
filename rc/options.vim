"Vim options setting
"author:tracyone@live.cn

set filetype=text
if te#env#IsWindows()
    set makeprg=mingw32-make
    let $MYVIMRC=$VIMFILES.'/vimrc'
else
    set keywordprg=""
    set path=.,/usr/include/
    lan time en_US.UTF-8
    lan ctype en_US.UTF-8
endif

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb1830,big5,euc-jp,euc-kr,gbk
if v:lang=~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif
source $VIMRUNTIME/delmenu.vim
lan mes en_US.UTF-8
"set langmenu=nl_NL.ISO_8859-1
scriptencoding utf-8

"list candidate word in statusline
set wildmenu
set wildmode=longest,full
set wildignore=*.swp,*.bak
set wildignore+=*.min.*,*.css.map
set wildignore+=*.jpg,*.png,*.gif
set wic
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
set mat=2  
set report=0  "Threshold for reporting number of lines changed
set lazyredraw  " Don't update the display while executing macros
set helplang=en,cn  "set helplang=en
set autoread   "autoread when a file is changed from the outside
set relativenumber number "show the line number for each line
set cmdheight=1  "number of lines used for the command-line
set showmatch "when inserting a bracket, briefly jump to its match
set printfont=Yahei_Mono:h10:cGB2312  "name of the font to be used for :hardcopy
set smartcase  "override 'ignorecase' when pattern has upper case characters
set confirm  "start a dialog when a command fails
set smartindent "do clever autoindenting
"set nowrap   "don't auto linefeed

"linux kernel coding stype
set tabstop=4  "number of spaces a <Tab> in the text stands for
set shiftwidth=4 "number of spaces used for each step of (auto)indent
set softtabstop=4  "if non-zero, number of spaces to insert for a <Tab>
set expandtab
set smarttab "a <Tab> in an indent inserts 'shiftwidth' spaces
set textwidth=80

set hlsearch "highlight all matches for the last used search pattern
set showmode "display the current mode in the status line
"set ruler  "show cursor position below each window
set selection=inclusive  ""old", "inclusive" or "exclusive"; how selecting text behaves
set is  "show match for partly typed search command
"set lbr "wrap long lines at a character in 'breakat'
set backspace=indent,eol,start  "specifies what <BS>, CTRL-W, etc. can do in Insert mode
set whichwrap=b,h,l,<,>,[,]  "list of menu_flags specifying which commands wrap to another line
set mouse=a "list of menu_flags for using the mouse,support all

"unnamed" to use the * register like unnamed register
"autoselect" to always put selected text on the clipboardset clipboard+=unnamed
set clipboard=unnamed
"set autochdir  "change to directory of file in buffer
"
if get(g:, 'airline_powerline_fonts') == 1
    let s:seperator='  '
else
    let s:seperator=' | '
endif

"statuslne
if get(g:,'feat_enable_airline') != 1
    function! MyStatusLine(type)
        let l:mystatus_line='%<%t%m%r%h%w'
        let l:mystatus_line.="%{exists('*fugitive#statusline')?\ fugitive#statusline()\ :\ ''}"
        if a:type == 1
            let l:mystatus_line.="%= %{exists(':TagbarToggle')?\ tagbar#currenttag('%s".s:seperator."'".",'')\ :\ ''}"
            let l:mystatus_line.="%{&ft}".s:seperator."%{(&fenc!=''?&fenc:&enc)}[%{&ff}]".s:seperator."%p%%[%l,%v]"
            let l:mystatus_line.=s:seperator."%{strftime(\"%m/%d\-\%H:%M\")} "
        endif
        if exists('g:asyncrun_status') && g:asyncrun_status !=# ''
            let l:mystatus_line.=s:seperator.g:asyncrun_status.' '
        endif
        return l:mystatus_line
    endfunction
    set statusline=%!MyStatusLine(1)
endif
set guitablabel=%N\ %t  "do not show dir in tab
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
set stal=1  "always show the tabline
set sessionoptions-=folds
set sessionoptions-=options
set ffs=unix,dos,mac
set diffopt=vertical
set shortmess=filnxtToOI
if te#env#IsNvim()
    " Use cursor shape feature
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'

    if exists('&inccommand')
        set inccommand=nosplit
    endif

    if has('vim_starting')
        syntax off
    endif
endif

if te#env#IsVim8()
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

"{{{fold setting
"folding type: manual, indent, expr, marker or syntax
set foldenable                  " enable folding
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
function! MyFoldText()
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

