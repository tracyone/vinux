scriptencoding utf-8

set timeout timeoutlen=1000 ttimeoutlen=100

call te#meta#init()

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

vnoremap < <gv
vnoremap > >gv

" in mac osx please set your option key as meta key

call te#meta#map('noremap','1','<esc>1gt')
call te#meta#map('noremap','2','<esc>2gt')
call te#meta#map('noremap','3','<esc>3gt')
call te#meta#map('noremap','4','<esc>4gt')
call te#meta#map('noremap','5','<esc>5gt')
call te#meta#map('noremap','6','<esc>6gt')
call te#meta#map('noremap','7','<esc>7gt')
call te#meta#map('noremap','8','<esc>8gt')
call te#meta#map('noremap','9','<esc>9gt')
""option+t
call te#meta#map('nnoremap','t',':tabnew<cr>')
call te#meta#map('inoremap','t','<esc>:tabnew<cr>')
"option+q
call te#meta#map('noremap','q',':nohls<CR>:MarkClear<cr>:redraw!<cr>')
"select all
call te#meta#map('noremap','a','gggH<C-O>G')
call te#meta#map('inoremap','a','<C-O>gg<C-O>gH<C-O>G')
call te#meta#map('cnoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('onoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('snoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('xnoremap','a','<C-C>ggVG')
"Alignment
call te#meta#map('nnoremap','=',' <esc>ggVG=``')
"move
call te#meta#map('inoremap','h','<Left>')
call te#meta#map('inoremap','l','<Right>')
call te#meta#map('inoremap','j','<Down>')
call te#meta#map('inoremap','k','<Up>')

"move between windows
call te#meta#map('nnoremap','h','  <C-w>h')
call te#meta#map('nnoremap','l','<C-w>l')
call te#meta#map('nnoremap','j','<C-w>j')
call te#meta#map('nnoremap','k','<C-w>k')

call te#meta#map('cnoremap','l','<right>')
call te#meta#map('cnoremap','j','<down>')
call te#meta#map('cnoremap','k','<up>')
call te#meta#map('cnoremap','b','<S-left>')

call te#meta#map('nnoremap','m',':call MouseToggle()<cr>')   
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
call te#meta#map('inoremap','b','<S-left>')
call te#meta#map('inoremap','f','<S-right>')
call te#meta#map('cnoremap','f','<S-right>')
call te#meta#map('cnoremap','h','<left>')

"move in cmd win
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
noremap! <expr> <SID>transposition getcmdpos()>strlen(getcmdline())?"\<Left>":getcmdpos()>1?'':"\<Right>"
noremap! <expr> <SID>transpose "\<BS>\<Right>".matchstr(getcmdline()[0 : getcmdpos()-2], '.$')
cmap   <script> <C-T> <SID>transposition<SID>transpose

" }}}
"update the _vimrc
nnoremap <leader>so :call te#utils#source_vimrc($MYVIMRC)<cr>
"open the vimrc in tab
nnoremap <leader>vc :tabedit $MYVIMRC<CR>:tabedit $VIMFILES/feature.vim<CR>:call te#utils#goto_cur_file(1)<cr>

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


"delete the ^M
nnoremap dm :%s/\r\(\n\)/\1/g<CR>

"cd to current buffer's path
nnoremap <silent> <leader>fc :call te#utils#goto_cur_file(0)<cr> 
nnoremap <silent> <c-F7> :call te#utils#goto_cur_file(0)<cr> 

nnoremap <F7> :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" dos to unix or unix to dos
nnoremap <Leader>td :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" open url on cursor with default browser
nnoremap <leader>o :call te#utils#open_url()<cr>
" linu number toggle
nnoremap <Leader>tn :call te#utils#nu_toggle()<cr>
" realtime underline word toggle
nnoremap <leader>th :call te#utils#OptionToggle("g:cursorword",[0,1])<cr>
" next buffer or tab
nnoremap <Leader>bn :bnext<cr>
" previous buffer or tab
nnoremap <Leader>bp :bprev<cr>
" delete buffer
nnoremap <Leader>bk :bdelete<cr>
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
nnoremap <Leader>qa :qa<cr>
" quit current window
nnoremap <Leader>qq :q<cr>
" quit all without save
nnoremap <Leader>qQ :qa!<cr>
" save and quit all
nnoremap <Leader>qs :wqa<cr>
" tab 1
nnoremap <leader>1 :call te#utils#tab_buf_switch(1)<cr>
" tab 2
nnoremap <leader>2 :call te#utils#tab_buf_switch(2)<cr>
" tab 3
nnoremap  <leader>3 :call te#utils#tab_buf_switch(3)<cr>
" tab 4
nnoremap  <leader>4 :call te#utils#tab_buf_switch(4)<cr>
" tab 5
nnoremap  <leader>5 :call te#utils#tab_buf_switch(5)<cr>
" tab 6
nnoremap  <leader>6 :call te#utils#tab_buf_switch(6)<cr>
" tab 7
nnoremap  <leader>7 :call te#utils#tab_buf_switch(7)<cr>
" tab 8
nnoremap  <leader>8 :call te#utils#tab_buf_switch(8)<cr>
" tab 9
nnoremap  <leader>9 :call te#utils#tab_buf_switch(9)<cr>

nnoremap <Left> :call te#utils#tab_buf_switch(0)<cr>

nnoremap <Right> :call te#utils#tab_buf_switch(-1)<cr>

" toggle coding style 
nnoremap <leader>tc :call te#utils#coding_style_toggle()<cr>
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
" move to left win
nnoremap <Leader>wh <C-w>h
" move to right win
nnoremap <Leader>wl <C-w>l
" move down win
nnoremap <Leader>wj <C-w>j
" move up win
nnoremap <Leader>wk <C-w>k
" toggle long or short statusline
nnoremap <leader>ts :call te#utils#OptionToggle('statusline',['%!MyStatusLine(1)','%!MyStatusLine(2)'])<cr>
" toggle paste option
nnoremap <leader>tp :call te#utils#OptionToggle("paste",[1,0])<cr>
" Toggle termguicolors
nnoremap <Leader>tl :call te#utils#OptionToggle('termguicolors',[1,0])<cr>
" feature enable
nnoremap <Leader>fe :call te#feat#feat_dyn_enable()<cr>

if te#env#IsNvim()
    "terminal-emulator setting
    execute 'tnoremap <Esc> <C-\><C-n>'
    execute 'tnoremap <A-h> <C-\><C-n><C-w>h'
    execute 'tnoremap <A-j> <C-\><C-n><C-w>j'
    execute 'tnoremap <A-k> <C-\><C-n><C-w>k'
    execute 'tnoremap <A-l> <C-\><C-n><C-w>l'
endif
