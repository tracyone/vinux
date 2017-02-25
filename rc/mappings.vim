
"meta key handle... {{{
if !te#env#IsNvim()
    if(!te#env#IsGui())
        let c='a'
        while c <=# 'z'
            exec 'set <m-'.c.">=\e".c
            exec "inoremap \e".c.' <m-'.c.'>'
            let c = nr2char(1+char2nr(c))
        endw
        let d='1'
        while d <=? '9'
            exec 'set <m-'.d.">=\e".d
            exec "inoremap \e".d.' <m-'.d.'>'
            let d = nr2char(1+char2nr(d))
        endw
    endif
endif

if te#env#IsMacVim()
    let s:alt_char={1:'¡',2:'™',3:'£',4:'¢',5:'∞',6:'§',7:'¶',8:'•',9:'ª'
                \,'t':'†','q':'œ','a':'å','=':'≠','h':'˙','l':'¬','j':'∆','k':'˚'
                \,'o':'ø','-':'–','b':'∫','f':'ƒ','m':'µ','w':'∑'}
elseif te#env#IsUnix() && !te#env#IsNvim() && !te#env#IsGui()
    let s:alt_char={1:'±' ,2:'²',3:'³',4:'´',5:'µ',6:'¶',7:'·',8:'¸',9:'¹'
                \,'t':'ô','q':'ñ','a':'á','=':'½','h':'è','l':'ì','j':'ê','k':'ë'
                \,'o':'ï','-':'­','b':'â','f':'æ','m':'í','w':'÷'}
elseif te#env#IsGui() || te#env#IsNvim()
    let s:alt_char={1:'<m-1>',2:'<m-2>',3:'<m-3>',4:'<m-4>',5:'<m-5>',6:'<m-6>',7:'<m-7>',8:'<m-8>',9:'<m-9>'
                \,'t':'<m-t>','q':'<m-q>','a':'<m-a>','=':'<m-=>','h':'<m-h>','l':'<m-l>','j':'<m-j>','k':'<m-k>'
                \,'o':'<m-o>','-':'<m-->','b':'<m-b>','f':'<m-f>','m':'<m-m>','w':'<m-w>'}
endif

function! TracyoneAltMap(maptype,keycodes,action) abort
    execute a:maptype.' '.s:alt_char[a:keycodes].' '.a:action
endfunction
"}}}

set timeout timeoutlen=1000 ttimeoutlen=100
""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no

"leader key
let g:mapleader="\<Space>"
let g:maplocalleader=','

"map jj to esc..
inoremap jj <c-[>

vnoremap [p "0p

"visual mode hit tab forward indent ,hit shift-tab backward indent
vnoremap <TAB>  >gv  
vnoremap <s-TAB>  <gv 
"Ctrl-tab is not work in vim
nnoremap <silent><c-TAB> :AT<cr>
nnoremap <silent><right> :tabnext<cr>
nnoremap <silent><Left> :tabp<cr>

" in mac osx please set your option key as meta key

call TracyoneAltMap('noremap','1','<esc>1gt')
call TracyoneAltMap('noremap','2','<esc>2gt')
call TracyoneAltMap('noremap','3','<esc>3gt')
call TracyoneAltMap('noremap','4','<esc>4gt')
call TracyoneAltMap('noremap','5','<esc>5gt')
call TracyoneAltMap('noremap','6','<esc>6gt')
call TracyoneAltMap('noremap','7','<esc>7gt')
call TracyoneAltMap('noremap','8','<esc>8gt')
call TracyoneAltMap('noremap','9','<esc>9gt')
""option+t
call TracyoneAltMap('nnoremap','t',':tabnew<cr>')
call TracyoneAltMap('inoremap','t','<esc>:tabnew<cr>')
"option+q
call TracyoneAltMap('noremap','q',':nohls<CR>:MarkClear<cr>:redraw!<cr>')
"select all
call TracyoneAltMap('noremap','a','gggH<C-O>G')
call TracyoneAltMap('inoremap','a','<C-O>gg<C-O>gH<C-O>G')
call TracyoneAltMap('cnoremap','a','<C-C>gggH<C-O>G')
call TracyoneAltMap('onoremap','a','<C-C>gggH<C-O>G')
call TracyoneAltMap('snoremap','a','<C-C>gggH<C-O>G')
call TracyoneAltMap('xnoremap','a','<C-C>ggVG')
"Alignment
call TracyoneAltMap('nnoremap','=',' <esc>ggVG=``')
"move
call TracyoneAltMap('inoremap','h','<Left>')
call TracyoneAltMap('inoremap','l','<Right>')
call TracyoneAltMap('inoremap','j','<Down>')
call TracyoneAltMap('inoremap','k','<Up>')

"move between windows
call TracyoneAltMap('nnoremap','h','  <C-w>h')
call TracyoneAltMap('nnoremap','l','<C-w>l')
call TracyoneAltMap('nnoremap','j','<C-w>j')
call TracyoneAltMap('nnoremap','k','<C-w>k')

call TracyoneAltMap('cnoremap','l','<right>')
call TracyoneAltMap('cnoremap','j','<down>')
call TracyoneAltMap('cnoremap','k','<up>')
call TracyoneAltMap('cnoremap','b','<S-left>')

call TracyoneAltMap('nnoremap','m',':call MouseToggle()<cr>')   
" Mouse mode toggle
nnoremap <leader>tm :call te#utils#OptionToggle('mouse',['a',''])<cr>

" GNU readline keybinding {{{
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap        <C-B> <Left>
inoremap        <C-f> <right>
"Delete the character underneath the cursor.
inoremap        <C-d> <BS>
"Delete the character underneath the cursor.
inoremap        <C-h> <BS>
cnoremap        <C-B> <Left>
cnoremap        <C-f> <right>
" Move forward a word or Move backward a word.
call TracyoneAltMap('inoremap','b','<S-left>')
call TracyoneAltMap('inoremap','f','<S-right>')
call TracyoneAltMap('cnoremap','f','<S-right>')
call TracyoneAltMap('cnoremap','h','<left>')

"move in cmd win
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
noremap! <expr> <SID>transposition getcmdpos()>strlen(getcmdline())?"\<Left>":getcmdpos()>1?'':"\<Right>"
noremap! <expr> <SID>transpose "\<BS>\<Right>".matchstr(getcmdline()[0 : getcmdpos()-2], '.$')
cmap   <script> <C-T> <SID>transposition<SID>transpose

" }}}
"update the _vimrc
nnoremap <leader>so :call te#utils#SourceRc($MYVIMRC)<cr>
"open the vimrc in tab
nnoremap <leader>vc :tabedit $MYVIMRC<CR>

"clear search result

"save file 
"in terminal ctrl-s is used to stop printf..
noremap <C-S>	:call te#utils#SaveFiles()<cr>
vnoremap <C-S>	<C-C>:call te#utils#SaveFiles()<cr>
inoremap <C-S>	<C-O>:call te#utils#SaveFiles()<cr>

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
nnoremap <silent> <leader>fc :call te#utils#goto_cur_file()<cr> 
nnoremap <silent> <c-F7> :call te#utils#goto_cur_file()<cr> 

nnoremap <F7> :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" dos to unix or unix to dos
nnoremap <Leader>td :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" open url on cursor with default browser
nnoremap <leader>o :call te#utils#open_url()<cr>
" linu number toggle
nnoremap <Leader>tn :call te#utils#nu_toggle()<cr>
