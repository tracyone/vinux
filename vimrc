"@file       vimrc 
"@brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"@date       2015-11-28/22:56:20
"@author     tracyone,tracyone@live.cn,
"@github     https://github.com/tracyone/t-vim
"@website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"System check{{{
let s:is_unix  = ( has('mac') + has("unix") )
let s:is_win   = has("win32") + has("win64")
let s:is_nvim  = has('nvim')
let s:is_gui   = has("gui_running") + has('gui_macvim')
let s:has_python = has("python")
let s:has_python3 = has("python3")
let s:python_ver=s:has_python+s:has_python3

set filetype=text
if s:is_win
    let $HOME=$VIM
    let $VIMFILES = $VIM.'/vimfiles'
    set makeprg=mingw32-make
    if s:is_win == 2 | let s:cpu_arch = "x86_64" | endif
else
    set keywordprg=""
    set path=.,/usr/include/
    let $VIMFILES = $HOME.'/.vim'
    let s:cpu_arch = system('uname -m')[:-2]
endif


"}}}
"Basic setting{{{

"Encode {{{
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
"}}}

"{{{autocmd autogroup

augroup fold_group
    autocmd!
augroup END

augroup quickfix_group
    autocmd!
    au BufWinEnter quickfix  noremap <buffer> q :q<cr>
    " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
    autocmd BufReadPost quickfix nnoremap <buffer> s <C-w><Enter><C-w>K
augroup END

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
    au FileType verilog setlocal tabstop=3
    au FileType verilog setlocal shiftwidth=3
    au FileType verilog setlocal softtabstop=3
    au FileType c,cpp,java,vim,verilog setlocal expandtab "instead tab with space 
    au FileType make setlocal noexpandtab
    au FileType markdown setlocal nospell
    au FileType vim setlocal fdm=marker
    au BufRead,BufNewFile *.hex,*.out,*.o,*.a Vinarise
augroup END

"}}}

"{{{fold setting
"folding type: manual, indent, expr, marker or syntax
set foldenable                  " enable folding
autocmd fold_group FileType c,cpp setlocal foldmethod=syntax 
autocmd fold_group FileType verilog setlocal foldmethod=marker 
autocmd fold_group FileType verilog setlocal foldmarker=begin,end 
autocmd fold_group FileType sh setlocal foldmethod=indent
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
function! MyFoldText()
    let line = getline(v:foldstart)
    if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
        let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
        let linenum = v:foldstart + 1
        while linenum < v:foldend
            let line = getline( linenum )
            let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
            if comment_content != ''
                break
            endif
            let linenum = linenum + 1
        endwhile
        let sub = initial . ' ' . comment_content
    else
        let sub = line
        let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
        if startbrace == '{'
            let line = getline(v:foldend)
            let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
            if endbrace == '}'
                let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
            endif
        endif
    endif
    let n = v:foldend - v:foldstart + 1
    let info = " " . n . " lines"
    let sub = sub . "                                                                                                                  "
    let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    let fold_w = getwinvar( 0, '&foldcolumn' )
    let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
    return sub . info
endfunction
set foldtext=MyFoldText()
nnoremap sj za
vnoremap sf zf
nnoremap sk zM
nnoremap si zi
"}}}

"list candidate word in statusline
set wildmenu
set wildmode=longest,full
set wic
"set list  "display unprintable characters by set list
set listchars=tab:\|\ ,trail:-  "Strings to use in 'list' mode and for the |:list| command
au misc_group BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "jump to last position last open in vim

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

"{{{backup
set backup "generate a backupfile when open file
set backupext=.bak  "backup file'a suffix
set backupdir=$VIMFILES/vimbackup  "backup file's directory
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
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
set cindent  "enable specific indenting for C code
set tabstop=4  "number of spaces a <Tab> in the text stands for
set softtabstop=4  "if non-zero, number of spaces to insert for a <Tab>
set smarttab "a <Tab> in an indent inserts 'shiftwidth' spaces
set hlsearch "highlight all matches for the last used search pattern
set shiftwidth=4 "number of spaces used for each step of (auto)indent
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
set clipboard+=unnamed
"set autochdir  "change to directory of file in buffer

"statuslne
" check for the existance of specified plugin
function! TracyoneHasPlugin(name)
    let l:pat='bundle/'.a:name
    return !empty(globpath(&rtp, pat))
endfunction

if TracyoneHasPlugin("tagbar") && TracyoneHasPlugin("vim-fugitive")
    set statusline=%<%t%m%r%h%w%{tagbar#currenttag('[%s]','')}
    set statusline+=%=[%{(&fenc!=''?&fenc:&enc)}\|%{&ff}\|%Y][%l,%v][%p%%]%{fugitive#statusline()}
    set statusline+=[%{strftime(\"%m/%d\-\%H:%M\")}]
else
    set statusline=%<%t%m%r%h%w
    set statusline+=%=[%{(&fenc!=''?&fenc:&enc)}\|%{&ff}\|%Y][%l,%v][%p%%]
    set statusline+=[%{strftime(\"%m/%d\-\%H:%M\")}]
endif
set guitablabel=%N\ %t  "do not show dir in tab
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
set stal=1  "always show the tabline
set sessionoptions-=folds
set sessionoptions-=options
set ffs=unix,dos,mac
au misc_group BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  


if(s:is_nvim== 1)
    "terminal-emulator setting
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif


"}}}
"Key mapping{{{

"map jj to esc..
"fuck the meta key...
if s:is_nvim != 1
    if(!s:is_gui)
        let c='a'
        while c <= 'z'
            exec "set <m-".c.">=\e".c
            exec "inoremap \e".c." <m-".c.">"
            let c = nr2char(1+char2nr(c))
        endw
        let d='1'
        while d <= '9'
            exec "set <m-".d.">=\e".d
            exec "inoremap \e".d." <m-".d.">"
            let d = nr2char(1+char2nr(d))
        endw
        set timeout timeoutlen=500 ttimeoutlen=1
    endif
endif

""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no

"leader key
let mapleader="\<Space>"
inoremap jj <c-[>

vnoremap [p "0p

"visual mode hit tab forward indent ,hit shift-tab backward indent
vnoremap <TAB>  >gv  
vnoremap <s-TAB>  <gv 
"Ctrl-tab is not work in vim
nnoremap <silent><c-TAB> :AT<cr>
nnoremap <silent><right> :tabnext<cr>
nnoremap <silent><Left> :tabp<cr>
au misc_group FileType c,cpp nnoremap <silent> K :call TracyoneFindMannel()<cr>

"{{{ alt or meta key mapping
" in mac osx please set your option key as meta key
if s:is_gui == 2 "macvim
    let s:alt_char={1:"¡",2:"™",3:"£",4:"¢",5:"∞",6:"§",7:"¶",8:"•",9:"ª"
                \,'t':"†",'q':"œ",'a':"å",'=':"≠",'h':"˙",'l':"¬",'j':"∆",'k':"˚"
                \,'o':"ø",'-':"–",'b':"∫",'f':"ƒ",'m':"µ",'w':"∑"}
elseif s:is_unix && !s:is_nvim && !s:is_gui   "linux and not neovim and not gvim
    let s:alt_char={1:"±" ,2:"²",3:"³",4:"´",5:"µ",6:"¶",7:"·",8:"¸",9:"¹"
                \,'t':"ô",'q':"ñ",'a':"á",'=':"½",'h':"è",'l':"ì",'j':"ê",'k':"ë"
                \,'o':"ï",'-':"­",'b':"â",'f':"æ",'m':"í",'w':"÷"}
elseif s:is_gui || s:is_nvim "gvim or neovim
    let s:alt_char={1:"<m-1>",2:"<m-2>",3:"<m-3>",4:"<m-4>",5:"<m-5>",6:"<m-6>",7:"<m-7>",8:"<m-8>",9:"<m-9>"
                \,'t':"<m-t>",'q':"<m-q>",'a':"<m-a>",'=':"<m-=>",'h':"<m-h>",'l':"<m-l>",'j':"<m-j>",'k':"<m-k>"
                \,'o':"<m-o>",'-':"<m-->",'b':"<m-b>",'f':"<m-f>",'m':"<m-m>",'w':"<m-w>"}
endif

exec "noremap " .s:alt_char[1] . " <esc>1gt"
exec "noremap ". s:alt_char[2]." <esc>2gt" 
exec "noremap ". s:alt_char[3]." <esc>3gt" 
exec "noremap ". s:alt_char[4]." <esc>4gt" 
exec "noremap ". s:alt_char[5]." <esc>5gt"  
exec "noremap ". s:alt_char[6]." <esc>6gt" 
exec "noremap ". s:alt_char[7]." <esc>7gt" 
exec "noremap ". s:alt_char[8]." <esc>8gt" 
exec "noremap ". s:alt_char[9]." <esc>9gt" 
"option+t
exec "nnoremap ". s:alt_char['t']." :tabnew<cr>" 
exec "inoremap ". s:alt_char['t']." <esc>:tabnew<cr>" 
"option+q
exec "noremap ".  s:alt_char['q']." :nohls<CR>:MarkClear<cr>:redraw!<cr>"  
"select all
exec "noremap ".  s:alt_char['a']." gggH<C-O>G"
exec "inoremap ". s:alt_char['a']." <C-O>gg<C-O>gH<C-O>G" 
exec "cnoremap ". s:alt_char['a']." <C-C>gggH<C-O>G" 
exec "onoremap ". s:alt_char['a']." <C-C>gggH<C-O>G" 
exec "snoremap ". s:alt_char['a']." <C-C>gggH<C-O>G" 
exec "xnoremap ". s:alt_char['a']." <C-C>ggVG" 
"Alignment
exec "nnoremap ". s:alt_char['=']."  <esc>ggVG=``" 
"move
exec "inoremap ". s:alt_char['h']." <Left>" 
exec "inoremap ". s:alt_char['l']." <Right>" 
exec "inoremap ". s:alt_char['j']." <Down>" 
exec "inoremap ". s:alt_char['k']." <Up>" 
exec "inoremap " .s:alt_char["b"]." <S-left>"
exec "inoremap " .s:alt_char["f"]." <S-right>"

"move between windows
exec "nnoremap " s:alt_char['h']."   <C-w>h" 
exec "nnoremap " .s:alt_char['l']. " <C-w>l"
exec "nnoremap " .s:alt_char['j']. " <C-w>j"
exec "nnoremap " .s:alt_char['k']. " <C-w>k"

exec "cnoremap " .s:alt_char['l']. " <right>"
exec "cnoremap " .s:alt_char['j']. " <down>"
exec "cnoremap " .s:alt_char['k']. " <up>"
exec "cnoremap " .s:alt_char["b"]." <S-left>"
exec "cnoremap " .s:alt_char["f"]." <S-right>"
exec "cnoremap " s:alt_char['h']." <left>" 

exec "nnoremap " s:alt_char["m"] " :call MouseToggle()<cr>"
" Mouse mode toggle
nnoremap <leader>tm :call MouseToggle()<cr>
" }}}

"home end move
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap        <C-B> <Left>
inoremap        <C-f> <right>
cnoremap        <C-B> <Left>
cnoremap        <C-f> <right>


"move in cmd win
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
noremap! <expr> <SID>transposition getcmdpos()>strlen(getcmdline())?"\<Left>":getcmdpos()>1?'':"\<Right>"
noremap! <expr> <SID>transpose "\<BS>\<Right>".matchstr(getcmdline()[0 : getcmdpos()-2], '.$')
cmap   <script> <C-T> <SID>transposition<SID>transpose

"update the _vimrc
nnoremap <leader>so :source $MYVIMRC<CR>
"open the vimrc in tab
nnoremap <leader>vc :tabedit $MYVIMRC<CR>

"clear search result

"save file 
"in terminal ctrl-s is used to stop printf..
noremap <C-S>	:call Tracyone_SaveFile()<cr>
vnoremap <C-S>	<C-C>:call Tracyone_SaveFile()<cr>
inoremap <C-S>	<C-O>:call Tracyone_SaveFile()<cr>

"copy,paste and cut 
noremap <S-Insert> "+gP
inoremap <c-v>	<C-o>"+gp
cmap <C-V>	<C-R>+
cmap <S-Insert>	<C-R>+
vnoremap <C-X> "+x


" CTRL-C and SHIFT-Insert are Paste
vnoremap <C-C> "+y

"change the windows size,f9, f10, f11, f12 --> hj, j, k, l
noremap <silent> <C-F9> :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
" vertical increase window's size
noremap <silent> <leader>w. :vertical resize +10<CR>
" vertical decrease window's size
noremap <silent> <leader>w, :vertical resize -10<CR>
" horizontal decrease window's size
noremap <silent> <leader>w- :resize -10<CR>
" horizontal increase window's size
noremap <silent> <leader>w= :resize +10<CR>


"replace
nnoremap <c-h> :OverCommandLine<cr>:%s/<C-R>=expand("<cword>")<cr>/
vnoremap <c-h> :OverCommandLine<cr>:<c-u>%s/<C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>/
"delete the ^M
nnoremap dm :%s/\r\(\n\)/\1/g<CR>

"cd to current buffer's path
nnoremap <silent> <leader>fc :call GotoCurFile()<cr> 
nnoremap <silent> <c-F7> :call GotoCurFile()<cr> 
"resize windows
noremap <F5> :call Do_Make()<CR>
" make
nnoremap <leader>cC :call Do_Make()<cr>

nnoremap <F7> :call Dosunix()<cr>:call s:EchoWarning("Dos2unix...")<cr>
" dos to unix or unix to dos
nnoremap <Leader>td :call Dosunix()<cr>:call s:EchoWarning("Dos2unix...")<cr>
" open url on cursor with default browser
nnoremap <leader>o :call Open_url()<cr>

"}}}
"Function{{{
function! TracyoneFindMannel()
    let l:cur_word=expand("<cword>")
    let l:ret = s:TracyoneGetError("Snman 3 ".l:cur_word,"no manual.*")
    "make sure index valid
    if l:ret != 0
        let l:ret = s:TracyoneGetError("Snman 2 ".l:cur_word,"no manual.*")
        if l:ret != 0
            execute "silent! help ".l:cur_word
        endif
    else
        execute "Snman 2 ".l:cur_word
    endif
endfunction

" name :s:TracyoneGetError
" arg  :command,vim command(not shell command) that want to
"       test execute status
" arg   : err_str,error substring pattern that is expected
" return:return 0 if no error exist,return -1 else
function! s:TracyoneGetError(command,err_str)
    redir => l:msg
    silent! execute a:command
    redir END
    let l:rs=split(l:msg,'\r\n\|\n')
    if get(l:rs,-1,3) ==3  "no error exists
        return 0
    elseif l:rs[-1] =~# a:err_str
        return -1
    else
        return 0
    endif
endfunction

function! Tracyone_SaveFile()
    try 
        update
    catch /^Vim\%((\a\+)\)\=:E212/
        if exists(":SudoWrite")
            call s:EchoWarning("sudo write,please input your password!")
            SudoWrite %
            return 0
        endif
    catch /^Vim\%((\a\+)\)\=:E32/   "no file name
        if s:is_gui
            exec ":emenu File.Save"
            return 0
        endif
        let l:filename=input("NO FILE NAME!Please input the file name: ")
        if l:filename == ""
            call s:EchoWarning("You just give a empty name!")
            return 3
        endif
        try 
            exec "w ".l:filename
        catch /^Vim\%((\a\+)\)\=:E212/
            if exists(":SudoWrite")
                call s:EchoWarning("sudo write,please input your password!")
                SudoWrite %
                return 0
            endif
        endtry
    endtry
endfunction

function! Do_Make()
    :wa
    :Make
    :copen
    :exe "normal \<c-w>\<c-w>"
endfunction

function! s:Get_pattern_at_cursor(pat)
    let col = col('.') - 1
    let line = getline('.')
    let ebeg = -1
    let cont = match(line, a:pat, 0)
    while (ebeg >= 0 || (0 <= cont) && (cont <= col))
        let contn = matchend(line, a:pat, cont)
        if (cont <= col) && (col < contn)
            let ebeg = match(line, a:pat, cont)
            let elen = contn - ebeg
            break
        else
            let cont = match(line, a:pat, contn)
        endif
    endwhile
    if ebeg >= 0
        return strpart(line, ebeg, elen)
    else
        return ""
    endif
endfunction

function! GotoCurFile()
    execute "lcd %:h"
    execute ':call s:EchoWarning("cd to ".getcwd())'
endfunction
function! Open_url()
    let s:url = s:Get_pattern_at_cursor('\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?')
    if s:url == ""
        echohl WarningMsg
        echomsg 'It is not a URL on current cursor！'
        echohl None
    else
        echo 'Open URL：' . s:url
        if has("win32") || has("win64")
            call system("cmd /C start " . s:url)
        elseif has("mac")
            call system("open '" . s:url . "'")
        else
            call system("xdg-open '" . s:url . "' &")
        endif
    endif
    unlet s:url
endfunction

function! s:CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

func! Dosunix()
    if &ff == 'unix'
        exec "se ff=dos"
    else
        exec "se ff=unix"
    endif
endfunc

"echo warning messag
func! s:EchoWarning(str)
    redraw!
    echohl WarningMsg | echo a:str | echohl None
endfunc
let s:MouseFlag=1
func! MouseToggle()
    if s:MouseFlag==0
        :call s:EchoWarning("Mouse on")
        set mouse=a
        let s:MouseFlag=1
    else
        :call s:EchoWarning("Mouse off")
        set mouse&
        let s:MouseFlag=0
    endif
endfunc

function! TracyoneGotoDef(open_type)
    let l:cword=expand("<cword>")
    let l:ycm_ret=s:YcmGotoDef(a:open_type)
    if l:ycm_ret < 0
        try
            execute "cs find g ".l:cword
        catch /^Vim\%((\a\+)\)\=:E/	
            call s:EchoWarning("cscope query failed")
            if a:open_type != "" | wincmd q | endif
            return -1
        endtry
    else
        return 0
    endif
    return 0
endfunction

func! s:YcmGotoDef(open_type)
    let l:cur_word=expand("<cword>")."\s*\(.*[^;]$"
    if s:complete_plugin == 2
        if g:is_load_ycm != 1
            call s:EchoWarning("Loading ycm ...")
            call plug#load('ultisnips','YouCompleteMe')
            call delete(".ycm_extra_conf.pyc")  
            call youcompleteme#Enable() 
            let g:is_load_ycm = 1
            autocmd! load_us_ycm 
            sleep 1
            call s:EchoWarning("ycm has been loaded!")
        endif
    endif
    let l:ret = s:TracyoneGetError(":YcmCompleter GoToDefinition","Runtime.*")
    if l:ret == -1
        let l:ret = s:TracyoneGetError(":YcmCompleter GoToDeclaration","Runtime.*")
        if l:ret == 0
            execute ":silent! A"
            " search failed then go back
            if search(l:cur_word) == 0
                execute ":silent! A"
                return -2
            endif
        else
            return -3 
        endif
    endif
    return 0
endfunc

function! TracyoneNext()
    if exists( '*tabpagenr' ) && tabpagenr('$') != 1
        " Tab support && tabs open
        normal gt
    else
        " No tab support, or no tabs open
        execute ":bnext"
    endif
endfunction
function! TracyonePrev()
    if exists( '*tabpagenr' ) && tabpagenr('$') != '1'
        " Tab support && tabs open
        normal gT
    else
        " No tab support, or no tabs open
        execute ":bprev"
    endif
endfunction

function! TracyoneBgToggle()
    if &bg == "dark"
        set bg=light
    else
        set bg=dark
    endif
endfunction
"}}}
"Plugin setting{{{
" Vim-plug ------------------------{{{
let &rtp=&rtp.",".$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    silent! exec ":!mkdir -p ".$VIMFILES."/autoload"
    exec ":!curl -fLo " . $VIMFILES."/autoload"."/plug.vim " .
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall
endif
call plug#begin($VIMFILES."/bundle")
Plug 'tracyone/a.vim'
if has('win64') || s:cpu_arch == "x86_64" || empty(glob($VIMFILES."/bundle/YouCompleteMe/third_party/ycmd/ycm_core.*")) == 0
    if s:python_ver
        Plug 'Valloric/YouCompleteMe', { 'on': [] }
        Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
    endif
    let s:complete_plugin=2
    let g:is_load_ycm = 0
else
    let s:complete_plugin=1
    Plug 'Shougo/neocomplete'
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
endif

Plug 'tracyone/hex2ascii.vim', { 'do': 'make' }
Plug 'rking/ag.vim',{'on': 'Ag'}
Plug 'thinca/vim-qfreplace'
Plug 'vim-scripts/verilog.vim'
Plug 'easymotion/vim-easymotion', { 'on': [ '<Plug>(easymotion-lineforward)',
            \ '<Plug>(easymotion-linebackward)','<Plug>(easymotion-overwin-w)' ]}
Plug 'thinca/vim-quickrun'
"some awesome vim colour themes
if s:is_gui
    Plug 'thinca/vim-fontzoom',{'on': ['<Plug>(fontzoom-smaller)', '<Plug>(fontzoom-larger)'] }
endif
Plug 'sjl/badwolf'
Plug 'altercation/vim-colors-solarized'
Plug 'cocopon/iceberg.vim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'KabbAmine/yowish.vim'
"some productive plugins
Plug 'terryma/vim-multiple-cursors'
if s:has_python
    Plug 'ashisha/image.vim'
endif
Plug 'terryma/vim-expand-region'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky',{'on': 'CtrlPFunky'}
Plug 'fisadev/vim-ctrlp-cmdpalette',{'on': 'CtrlPCmdPalette'}
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'jaxbot/github-issues.vim', { 'on': 'Gissue' }
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/genutils'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'arecarn/selection.vim' | Plug 'arecarn/crunch.vim'
"Plug 'youjumpiwatch/vim-neoeclim'
Plug 'mhinz/vim-startify'
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'tracyone/snippets'
Plug 'ianva/vim-youdao-translater', {'do': 'pip install requests --user','on': ['Ydc','Ydv']}
if s:python_ver | Plug 'iamcco/markdown-preview.vim' | endif
Plug 'mzlogin/vim-markdown-toc'
if(!s:is_win)
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'lucidstack/ctrlp-tmux.vim',{'on': 'CtrlPTmux'}
    Plug 'vim-scripts/sudo.vim'
    Plug 'nhooyr/neoman.vim'
    Plug 'tracyone/pyclewn_linux',{'branch': 'pyclewn-1.11'}
    if s:is_unix == 2
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote'}
    else
        Plug 'CodeFalling/fcitx-vim-osx'
    endif
endif
if s:is_nvim == 0
    Plug 'Shougo/vimproc.vim', { 'do': 'make;mingw32-make.exe -f make_mingw64.mak' }
    Plug 'Shougo/vimshell.vim'
    Plug 'vim-scripts/YankRing.vim'
else
    Plug 'mattn/ctrlp-register',{'on': 'CtrlPRegister'}
endif
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   }
Plug 'vim-scripts/L9'
Plug 'mattn/emmet-vim',{'for': 'html'}
Plug 'junegunn/vim-easy-align',{'on': [ '<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)' ]}
Plug 'adah1972/fencview',{'on': 'FencManualEncoding'}
Plug 'vim-scripts/DrawIt',{'on': 'DIstart'}
Plug 'mbbill/VimExplorer',{'on': 'VE'}
Plug 'vim-scripts/renamer.vim',{'on': 'Ren'}
Plug  'hari-rangarajan/CCTree'
Plug 'tracyone/mark.vim'
Plug 'tpope/vim-repeat' "repeat enhance
Plug 'Shougo/vinarise.vim'
Plug 'tracyone/love.vim'
Plug 't9md/vim-choosewin'
Plug 'itchyny/vim-cursorword'
Plug 'justinmk/vim-gtfo' "got to file explorer or terminal
Plug 'ktonga/vim-follow-my-lead'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'osyo-manga/vim-over'
Plug 'rhysd/github-complete.vim'
Plug 'skywind3000/asyncrun.vim'
" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()
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

" Cscope --------------------------{{{
function! TracyoneAddCscopeOut()
    if empty(glob(".project"))
        exec "silent! cs add cscope.out"
    else
        for s:line in readfile(".project", '')
            exec "silent! cs add ".s:line."/cscope.out"
        endfor
    endif
endfunction
:call TracyoneAddCscopeOut()
if $CSCOPE_DB != "" "tpyically it is a include db 
    exec "silent! cs add $CSCOPE_DB"
endif
if $CSCOPE_DB1 != ""
    exec "silent! cs add $CSCOPE_DB1"
endif
if $CSCOPE_DB2 != ""
    exec "silent! cs add $CSCOPE_DB2"
endif
if $CSCOPE_DB3 != ""
    exec "silent! cs add $CSCOPE_DB3"
endif
if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    set csprg=cscope
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
    set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
    " add any cscope database in current directory
    " else add the database pointed to by environment variable 
    set cscopetagorder=0
endif
set cscopeverbose 
" show msg when any other cscope db added
nnoremap ,s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap ,g :call TracyoneGotoDef("")<cr>
nnoremap ,d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:cw 7<cr>
nnoremap ,c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap ,t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap ,e :cs find e <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
"nnoremap ,f :cs find f <C-R>=expand("<cfile>")<CR><CR>:cw 7<cr>
nnoremap ,i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw 7<cr>

nnoremap <C-\>s :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :call TracyoneGotoDef("sp")<cr>
nnoremap <C-\>d :split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <C-\>c :split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

nnoremap ,u :call TracyoneGenCsTag()<cr>
nnoremap ,a :call TracyoneAddCscopeOut()<cr>
"kill the connection of current dir 
nnoremap ,k :cs kill cscope.out<cr> 

function! TracyoneGenCsTag()
    if empty(glob(".project"))
        :call Do_CsTag(getcwd())
    else
        for l:line in readfile(".project", '')
            let l:ans=input("Generate cscope database in ".l:line." [y/n/a]?","y")
            if l:ans =~# '\v^[yY]$'
                call Do_CsTag(l:line)
            endif
        endfor
    endif
endfunction

function! Do_CsTag(dir)
    if(s:is_win)
        let l:tagfile=a:dir."\\"."tags"
        let l:cscopefiles=a:dir."\\"."cscope.files"
        let l:cscopeout=a:dir."\\"."cscope.out"
    else
        let l:tagfile=a:dir."/tags"
        let l:cscopefiles=a:dir."/cscope.files"
        let l:cscopeout=a:dir."/cscope.out"
    endif
    if filereadable("tags")
        let tagsdeleted=delete(l:tagfile)
        if(tagsdeleted!=0)
            :call s:EchoWarning("Fail to do tags! I cannot delete the tags")
            return
        endif
    endif
    if filereadable(a:dir."/cscope.files")
        let csfilesdeleted=delete(l:cscopefiles)
        if(csfilesdeleted!=0)
            :call s:EchoWarning("Fail to do cscope! I cannot delete the cscope.files")
            return
        endif
    endif
    if filereadable(a:dir."/cscope.out")
        let csoutdeleted=delete(l:cscopeout)
        if(csoutdeleted!=0)
            :call s:EchoWarning("I cannot delete the cscope.out,try again")
            echo "kill the cscope connection"
            if has("cscope") && filereadable(l:cscopeout)
                silent! execute "cs kill ".l:cscopeout
            endif
            let csoutdeleted=delete(l:cscopeout)
        endif
        if(csoutdeleted!=0)
            :call s:EchoWarning("I still cannot delete the cscope.out,failed to do cscope")
            return
        endif
    endif
    "if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    "endif
    if(executable('cscope') && has("cscope") )
        if(!s:is_win)
            silent! execute "!find " .a:dir. " -name \"*.[chsS]\" > "  . a:dir."/cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs,*.s,*.asm > ".a:dir."\cscope.files"
        endif
        if filereadable(l:cscopeout)
            silent! execute "cs kill ".l:cscopeout
        else
            :call s:EchoWarning("No cscope.out")
        endif
        exec "cd ".a:dir
        silent! execute "AsyncRun -post=cs\\ add\\ ".l:cscopeout. " cscope -Rbkq -i ".l:cscopefiles
        cd -
        execute "normal :"
    endif
    execute "redraw!"
endfunction
    "}}}

" Complete ------------------------{{{
"generate .ycm_extra_conf.py for current directory

" lazyload ultisnips and YouCompleteMe
if s:complete_plugin == 2
    augroup load_us_ycm
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips','YouCompleteMe')
                    \| call delete(".ycm_extra_conf.pyc")  | call youcompleteme#Enable() 
                    \| let g:is_load_ycm = 1 |  autocmd! load_us_ycm
    augroup END
else
    augroup load_us_ycm
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips')
                    \| autocmd! load_us_ycm
    augroup END

endif

if s:complete_plugin == 2
function! GenYCM()
    let l:cur_dir=getcwd()
    cd $VIMFILES/bundle/YCM-Generator
    :silent execute  ":!./config_gen.py ".l:cur_dir
    if v:shell_error == 0
        echom "Generate successfully!"
        :YcmRestartServer
    else
        echom "Generate failed!"
    endif
    exec ":cd ". l:cur_dir
endfunction
" jume to definition (YCM)
nnoremap <leader>jl :YcmCompleter GoToDeclaration<CR>
autocmd misc_group InsertLeave * if pumvisible() == 0|pclose|endif
let g:ycm_confirm_extra_conf=0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_semantic_triggers = {
  \   'c' : ['->', '    ', '.', ' ', '(', '[', '&'],
\     'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
\     'perl' : ['->', '::', ' '],
\     'php' : ['->', '::', '.'],
\     'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
\     'ruby' : ['.', '::'],
\     'lua' : ['.', ':']
\ }
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'startufy' : 1,
            \ 'pandoc' : 1,
            \ 'infolog' : 1,
            \ 'mail' : 1
            \}
let g:ycm_global_ycm_extra_conf = $VIMFILES . "/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
elseif s:complete_plugin == 1
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#data_directory = $VIMFILES . '/.neocomplete'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'cpp' : $VIMFILES.'/bundle/dict/cpp.dict',
                \ 'html' : $VIMFILES.'/bundle/dict/html.dict',
                \ 'c' : $VIMFILES.'/bundle/dict/c.dict',
                \ 'sh' : $VIMFILES.'/bundle/dict/bash.dict',
                \ 'dosbatch' : $VIMFILES.'/bundle/dict/batch.dict',
                \ 'tex' : $VIMFILES.'/bundle/dict/latex.dict',
                \ 'vim' : $VIMFILES.'/bundle/dict/vim.dict.txt',
                \ 'verilog' : $VIMFILES.'/bundle/dict/verilog.dict'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    "imap <expr> `  pumvisible() ? "\<Plug>(neocomplete_start_unite_quick_match)" : '`'
    " Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#sources#omni#input_patterns.php =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    " For smart TAB completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
           \ <SID>check_back_space() ? "\<TAB>" :
           \ neocomplete#start_manual_complete()
     function! s:check_back_space() 
       let col = col('.') - 1
       return !col || getline('.')[col - 1]  =~ '\s'
     endfunction
endif
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
nnoremap <leader>tn :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
inoremap <F12> <ESC> :NERDTreeToggle<CR>
"}}}

" A.vim ---------------------------{{{
":A switches to the header file corresponding to the current file being  edited (or vise versa)
":AS splits and switches
":AV vertical splits and switches
":AT new tab and switches
":AN cycles through matches
":IH switches to file under cursor
":IHS splits and switches
":IHV vertical splits and switches
":IHT new tab and switches
":IHN cycles through matches
" Open c family header in new tab
nnoremap <leader>iav :AT<cr>
"}}}

" DelimitMate ---------------------{{{
au FileType filetype_group verilog,c let b:delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 0
"}}}

" yankring ------------------------{{{
if s:is_nvim == 0
    nnoremap <c-y> :YRGetElem<CR>
    inoremap <c-y> <esc>:YRGetElem<CR>
    nnoremap <Leader>yy :YRGetElem<CR>
else
    nnoremap <c-y> :CtrlPRegister<cr>
    inoremap <c-y> <esc>:CtrlPRegister<cr>
    nnoremap <Leader>yy :CtrlPRegister<cr>
endif
let yankring_history_dir = $VIMFILES
let g:yankring_history_file = ".yank_history"
let g:yankring_default_menu_mode = 0
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
"}}}

" CCtree --------------------------{{{
let g:CCTreeKeyTraceForwardTree = '<C-\>>' "the symbol in current cursor's forward tree 
let g:CCTreeKeyTraceReverseTree = '<C-\><'
let g:CCTreeKeyHilightTree = '<C-\>l' " Static highlighting
let g:CCTreeKeySaveWindow = '<C-\>y'
let g:CCTreeKeyToggleWindow = '<C-\>w'
let g:CCTreeKeyCompressTree = 'zs' " Compress call-tree
let g:CCTreeKeyDepthPlus = '<C-\>='
let g:CCTreeKeyDepthMinus = '<C-\>-'
let CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
let  g:CCTreeJoinProg = 'cat' 
let  g:CCTreeJoinProgOpts = ""
"let g:CCTreeUseUTF8Symbols = 1
"map <F7> :CCTreeLoadXRefDBFromDisk $CCTREE_DB<cr> 
"}}}

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
endif
let g:ctrlp_funky_syntax_highlight = 0
let g:ctrlp_funky_matchtype = 'path'
nnoremap <c-k> :CtrlPFunky<Cr>
nnoremap <c-j> :CtrlPBuffer<Cr>
" ctrlp buffer 
nnoremap <Leader>bl :CtrlPBuffer<Cr>
nnoremap <c-l> :CtrlPMRUFiles<cr>
"CtrlP mru
nnoremap <Leader>fr :CtrlPMRUFiles<cr>
" CtrlP file
nnoremap <Leader>ff :CtrlP<cr>
" narrow the list down with a word under cursor
" CtrlP function 
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
" CtrlP cmd
nnoremap <Leader>pc :CtrlPCmdPalette<cr>
"CtrlP tmux session
nnoremap <Leader>pt :CtrlPTmux<cr>
" CtrlP function
nnoremap <Leader>pk :CtrlPFunky<cr>
"}}}

" VimExplorer ---------------------{{{
let g:VEConf_systemEncoding = 'cp936'
noremap <F11> :silent! VE .<cr>
" Open Vim File Explorer
nnoremap <Leader>fj :silent! VE .<cr>
"}}}

" UltiSnips -----------------------{{{
if  s:has_python == 1
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsListSnippets ="<c-tab>"
let g:UltiSnipsJumpForwardTrigge="<c-j>"
let g:UltiSnipsJumpBackwardTrigge="<c-k>"
let g:UltiSnipsSnippetDirectories=["bundle/snippets"]
let g:UltiSnipsSnippetsDir=$VIMFILES."/bundle/snippets"
"}}}

" FencView ------------------------{{{
let g:fencview_autodetect=0 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
function! FencToggle()
    if &fenc == "utf-8"
        FencManualEncoding cp936
        call s:EchoWarning("Chang encode to cp936")
    elseif &fenc == "cp936"
        FencManualEncoding utf-8
        call s:EchoWarning("Chang encode to utf-8")
    else
        call s:EchoWarning("Current file encoding is ".&fenc)
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
if(s:is_nvim== 0)
    let g:vimshell_user_prompt = '":: " . "(" . fnamemodify(getcwd(), ":~") . ")"'
    "let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_editor_command="gvim"
    if has('win32') || has('win64')
        " Display user name on Windows.
        let g:vimshell_prompt = $USERNAME."% "
    else
        " Display user name on Linux.
        let g:vimshell_prompt = $USER."% "
    endif
    "let g:vimshell_popup_command='rightbelow 10split'
    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
    call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
    augroup vimshell_group
        autocmd!
        au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head)
        au FileType vimshell :imap <buffer> <c-l> <Plug>(vimshell_clear)
        au FileType vimshell :imap <buffer> <c-p> <Plug>(vimshell_history_unite)
        au FileType vimshell :imap <buffer> <up> <Plug>(vimshell_history_unite)
        au FileType vimshell,neoman setlocal nonu nornu
        au FileType vimshell :imap <buffer> <c-d> <Plug>(vimshell_exit)
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
    execute "rightbelow ".l:line."split"
    if s:is_nvim | execute "terminal" | else | execute "VimShell" | endif
endfunction
noremap <F4> :call TracyoneVimShellPop()<cr>
" Open vimshell or neovim's emulator
nnoremap <Leader>as :call TracyoneVimShellPop()<cr>
"}}}

" Nerdcommander -------------------{{{
let g:NERDMenuMode=0
"}}}

" VimStartify ---------------------{{{
if s:is_win
    let g:startify_session_dir = $VIMFILES .'\sessions'
else
    let g:startify_session_dir = $VIMFILES .'/sessions'
endif
let g:startify_list_order = ['sessions', 'files']
let g:startify_change_to_dir = 1
let g:startify_files_number = 5 
let g:startify_change_to_vcs_root = 0
let g:startify_custom_header = [
            \ '       __             _         ',
            \ '      / /_     _   __(_)___ ___ ',
            \ '     / __/____| | / / / __ `__ \',
            \ '    / /_/_____/ |/ / / / / / / /',
            \ '    \__/      |___/_/_/ /_/ /_/ ',
            \ '                                ',                            
            \ '    <space>hk open keymap list',
            \ '    <space>vc open vimrc in new tab',
            \ '    author:tracyone at live dot cn',
            \ '',
            \ '',
            \ ]

noremap <F8> :SSave<cr>
" Open startify windows
nnoremap <Leader>bh :Startify<cr>
autocmd misc_group FileType startify setlocal buftype=
"}}}

" Eclim ---------------------------{{{
let g:EclimCompletionMethod = 'omnifunc'
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.cpp =
            \ '[^. *\t]\.\w*\|\h\w*::'
"}}}

" GlobalSearch --------------------{{{
if executable('ag')
    let g:ag_prg="ag"." --vimgrep --ignore 'cscope.*'"
    let g:ag_highlight=1
    let s:ag_ignored_directories = [ '.git', 'bin', 'log', 'build', 'node_modules', '.bundle', '.tmp','.svn' ]
    for dir in s:ag_ignored_directories
        let g:ag_prg .= " --ignore-dir=" . dir
    endfor
"ag search for the word on current curosr
nnoremap <leader>vv :exec ":Ag '\\b" . expand("<cword>") . "\\b'" . " ."<cr>
"ag search for the word on current curosr
vnoremap <leader>vv :<c-u>:exec ":Ag '" . getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1] . "'" . " ."<cr>
"ag search c family function
nnoremap <leader>vf :exec ":Ag " ."'" . expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]" ."'" . " ."<cr>
"ag search :TODO or FIXME
nnoremap <leader>vt :exec ":Ag -i ". "\"[/* ]+\(TODO\|FIXME\)\s*\""." ."<cr>

    set grepprg=ag\ --nogroup\ --nocolor
    set grepformat=%f:%l:%c%m
endif
autocmd misc_group FileType qf nnoremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR>
autocmd misc_group FileType gitcommit,qfreplace setlocal nofoldenable
"}}}

" Markdown ------------------------{{{
if  s:is_unix == 2
    let g:mkdp_path_to_chrome = "open -a safari"
elseif s:is_win
    let g:mkdp_path_to_chrome = "C:\\Program\ Files\ (x86)\\Google\\Chrome\\Application\\chrome.exe"
else
    let g:mkdp_path_to_chrome = "google-chrome"
endif
" Markdown preview in browser
nnoremap <leader>mp :MarkdownPreview<cr>
" generate markdown TOC
nnoremap <leader>mt :silent GenTocGFM<cr>
"}}}

" Git releate ---------------------{{{
nnoremap <F3> :Gstatus<cr>
" Open git status window
nnoremap <Leader>gs :Gstatus<cr>
" Open github url
nnoremap <Leader>gh :Gbrowse<cr>
" Open git log( browser mode)
nnoremap <Leader>gl :Gitv --all<cr>
" Open git log(file mode)
nnoremap <Leader>gL :Gitv! --all<cr>
" Open git log(file mode)
vnoremap <leader>gL :Gitv! --all<cr>
" Open git blame windows
nnoremap <Leader>gb :Gblame<cr>
" git diff current file (vimdiff)
nnoremap <Leader>gd :Gdiff<cr>
" list git issue
nnoremap <Leader>gi :Gissue<cr>
" git push origin master
nnoremap <Leader>gp :exec "Gpush origin " . fugitive#head()<cr>
"}}}

" neomake -------------------------{{{
let g:neomake_open_list=2
"}}}

" Vim-multiple-cursors ------------{{{
" }}}

" Easymotion ----------------------{{{
map W <Plug>(easymotion-lineforward)
map B <Plug>(easymotion-linebackward)
" MultiWindow easymotion for word
nmap <Leader>F <Plug>(easymotion-overwin-w)
" MultiChar easymotion
nmap <Leader>es <Plug>(easymotion-sn)
nmap <Leader>et <Plug>(easymotion-tn)
" MultiWindow easymotion for line
nmap <Leader>el <Plug>(easymotion-overwin-line)
" MultiWindow easymotion for char
nmap <Leader>ef <Plug>(easymotion-overwin-f)

let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0
" }}}

" Tmux-navigator ------------------{{{
if !s:is_win
    let g:tmux_navigator_no_mappings = 1
    exec "nnoremap <silent> ".s:alt_char['h'] ." :TmuxNavigateLeft<cr>"
    exec "nnoremap <silent> ".s:alt_char['l']." :TmuxNavigateRight<cr>"
    exec "nnoremap <silent>".s:alt_char['j']." :TmuxNavigateDown<cr>"
    exec "nnoremap <silent> ".s:alt_char['k']. " :TmuxNavigateUp<cr>"
    exec "nnoremap <silent> ".s:alt_char['w']. " :TmuxNavigatePrevious<cr>"
endif
" }}}

" Algin ---------------------------{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap <leader>al <Plug>(LiveEasyAlign)
nmap <leader>al <Plug>(LiveEasyAlign)
if !exists('g:easy_align_delimiters')
    let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
" }}}

" Quickrun ------------------------{{{
let g:quickrun_config = {
            \   "_" : {
            \       "outputter" : "message",
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

" Misc ---------------------------{{{
let g:fml_all_sources = 1
let g:asyncrun_bell=1
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
exec "map " .s:alt_char['o'] ." :Fontzoom!<cr>"
exec "map " .s:alt_char['-'] ." <Plug>(fontzoom-smaller)"
exec "map " .s:alt_char['='] ." <Plug>(fontzoom-larger)"
augroup QuickfixStatus
    au! BufWinEnter quickfix setlocal 
        \ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
augroup END

func! CursorwordToggle()
    if g:cursorword == 0
        let g:cursorword=1
    else
        let g:cursorword=0
    endif
endfunc

autocmd misc_group VimEnter * :let g:cursorword = 0

"remove mapping of * and # in mark.vim
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev


" realtime underline word toggle
nnoremap <leader>tu :call CursorwordToggle()<cr>
" YouDao translate
nnoremap <Leader>yd <esc>:Ydc<cr>
" YouDao translate (visual mode)
vnoremap <Leader>yd <esc>:Ydv<cr>
nnoremap <F10> <esc>:Ydc<cr>
vnoremap <F10> <esc>:Ydv<cr>
" vim calculator
nnoremap <Leader>ac :Crunch<cr>
" undo tree window toggle
nnoremap <leader>au :UndotreeToggle<cr>
"hex to ascii convert
nnoremap <leader>ah :call Hex2asciiConvert()<cr>
" next buffer or tab
nnoremap <Leader>bn :call TracyoneNext()<cr>
" previous buffer or tab
nnoremap <Leader>bp :call TracyonePrev()<cr>
" delete buffer
nnoremap <Leader>bk :bdelete<cr>
" open current file's position with default file explorer
nmap <Leader>bf gof
" open current file's position with default terminal
nmap <Leader>bt got
" open project's(pwd) position with default file explorer
nmap <Leader>bF goF
" open project's(pwd) position with default terminal
nmap <Leader>bT goT
" run Ag command
nnoremap <Leader>fg :Ag 
" save file
nnoremap <Leader>fs :call Tracyone_SaveFile()<cr>
" save all
nnoremap <Leader>fS :wa<cr>
" manpage or vimhelp on current curosr word
nnoremap <Leader>hm :call TracyoneFindMannel()<cr>
" list leader's map
nmap <Leader>hk <Plug>(FollowMyLead)<c-w>J
" quit all
nnoremap <Leader>qq :qa<cr>
" quit all without save
nnoremap <Leader>qQ :qa!<cr>
" save and quit all
nnoremap <Leader>qs :wqa<cr>
" open calendar
nnoremap <Leader>at :Calendar<cr>
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
nmap <Leader>w <Plug>(choosewin)
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
"Gui releate{{{
if s:is_gui
    if ( s:is_unix==2 )
        set guifont=Consolas:h16
    elseif s:is_unix == 1
        set guifont=Consolas\ 12
        set guifontwide=YaHei_Mono_Hybird_Consolas\ 12.5
    else
        set guifont=Monaco:h12:cANSI
        set guifontwide=YaHei_Mono:h12.5:cGB2312
    endif
    au misc_group GUIEnter * call s:MaximizeWindow()
    " turn on this option as well
    set guioptions-=b
    set guioptions-=m "whether use menu
    set guioptions-=r "whether show the rigth scroll bar
    set guioptions-=l "whether show the left scroll bar
    set guioptions-=T "whether show toolbar or not
    "highlight the screen line of the cursor
    func! MenuToggle()
        if &guioptions =~# '\a*[mT]\a*[mT]'
            :set guioptions-=T
            :set guioptions-=m
        else
            :set guioptions+=m
            :set guioptions+=T
        endif
    endfunc
    :call MenuToggle()
    nnoremap <c-F8> :call MenuToggle()<cr>
    " Menu and toolbar toggle(MacVIm and gvim)
    nnoremap <Leader>tg :call MenuToggle()<cr>
    set cul
    "toolbar ----------------- {{{
    if has("toolbar")
        if exists("*Do_toolbar_tmenu")
            delfun Do_toolbar_tmenu
        endif
        fun Do_toolbar_tmenu()
            tmenu ToolBar.Open		Open File
            tmenu ToolBar.Save		Save File
            tmenu ToolBar.SaveAll	Save All
            tmenu ToolBar.Print		Print
            tmenu ToolBar.Undo		Undo
            tmenu ToolBar.Redo		Redo
            tmenu ToolBar.Cut		Cut
            tmenu ToolBar.Copy		Copy
            tmenu ToolBar.Paste		Paste
            tmenu ToolBar.Find		Find&Replace
            tmenu ToolBar.FindNext	Find Next
            tmenu ToolBar.FindPrev	Find Prev
            tmenu ToolBar.Replace	Replace
            tmenu ToolBar.LoadSesn	Load Session
            tmenu ToolBar.SaveSesn	Save Session
            tmenu ToolBar.RunScript	Run a Vim Script
            tmenu ToolBar.Make		Make
            tmenu ToolBar.Shell		Shell
            tmenu ToolBar.RunCtags	ctags! -R
            tmenu ToolBar.TagJump	Jump to next tag
            tmenu ToolBar.Help		Help
            tmenu ToolBar.FindHelp	Search Help
        endfun
    endif
    "}}}
    "mouse ------------------- {{{
    " Set up the gui cursor to look nice
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
    amenu PopUp.-SEP3-	<Nop>
    ""extend", "popup" or "popup_setpos"; what the right
    set mousemodel=popup_setpos
    amenu PopUp.&Undo :UndotreeToggle<CR>
    amenu PopUp.&Goto\ Definition :cs find g <C-R>=expand("<cword>")<CR><CR>
    amenu PopUp.&Find\ Text :silent! execute "vimgrep " . expand("<cword>") . " **/*.[ch]". " **/*.cpp" . " **/*.cc"<cr>:cw 5<cr>
    amenu PopUp.&Open\ Header/Source :AT<cr>
    "}}}
    function! s:MaximizeWindow()
        if s:is_unix == 1
            :win 1999 1999
            silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
        elseif s:is_win
            :simalt~x "maximize window
        else
            :win 1999 1999
        endif
        ":set vb t_vb=
    endfunction
else
    set nocul
    set novb
    set t_vb=
    set t_ut=
    "highlight the screen line of the cursor
    set t_Co=256
endif

"{{{colorscheme
let g:solarized_bold=1
let g:solarized_underline=0
let g:solarized_termcolors=256
let g:solarized_menu=0
set background=dark
try 
    colorscheme PaperColor "default setting 
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert "default setting 
endtry

nnoremap <leader>tb :call TracyoneBgToggle()<cr>

"}}}
"}}}
"default is on but it is off when you are root,so we put it here
set modeline
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
