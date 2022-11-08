scriptencoding utf-8


call te#meta#init()


"map jj to esc..
inoremap jj <c-[>
cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'

inoremap j<Space>     j
cnoremap j<Space>     j

vnoremap [p "0p

vmap * y:let @/ = @"<CR>
"visual mode hit tab forward indent ,hit shift-tab backward indent
vnoremap <TAB>  >gv  
vnoremap <s-TAB>  <gv 
"Ctrl-tab is not work in vim
nnoremap <silent><c-TAB> :AT<cr>

vnoremap < <gv
vnoremap > >gv

" in mac osx please set your option key as meta key

call te#meta#map('noremap','1',':call te#utils#tab_buf_switch(1)<cr>')
call te#meta#map('noremap','2',':call te#utils#tab_buf_switch(2)<cr>')
call te#meta#map('noremap','3',':call te#utils#tab_buf_switch(3)<cr>')
call te#meta#map('noremap','4',':call te#utils#tab_buf_switch(4)<cr>')
call te#meta#map('noremap','5',':call te#utils#tab_buf_switch(5)<cr>')
call te#meta#map('noremap','6',':call te#utils#tab_buf_switch(6)<cr>')
call te#meta#map('noremap','7',':call te#utils#tab_buf_switch(7)<cr>')
call te#meta#map('noremap','8',':call te#utils#tab_buf_switch(8)<cr>')
call te#meta#map('noremap','9',':call te#utils#tab_buf_switch(9)<cr>')
""option+t
call te#meta#map('nnoremap','t',':tabnew<cr>')
call te#meta#map('inoremap','t','<esc>:tabnew<cr>')
"option+q
call te#meta#map('noremap <silent> ','q',':nohls<CR>:MarkClear<cr>:redraw!<cr>')
"no highlight
nnoremap  <silent> <Leader>nq :nohls<CR>:MarkClear<cr>:redraw!<cr>
"select all
call te#meta#map('noremap','a','gggH<C-O>G')
call te#meta#map('inoremap','a','<C-O>gg<C-O>gH<C-O>G')
call te#meta#map('cnoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('onoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('snoremap','a','<C-C>gggH<C-O>G')
call te#meta#map('xnoremap','a','<C-C>ggVG')
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
cnoremap <C-r><C-l> <C-r>=getline('.')<CR>
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

call te#meta#map('xnoremap','j',":m '>+1<CR>gv=gv")
call te#meta#map('xnoremap','k',":m '<-2<CR>gv=gv")

xnoremap  <silent><Leader>mj :m '>+1<CR>gv=gv
xnoremap  <silent><Leader>mk :m '<-2<CR>gv=gv
nnoremap  <silent><Leader>mj :m .+1<CR>==
nnoremap  <silent><leader>mk :m .-2<CR>==

" }}}
"update the _vimrc
nnoremap  <silent><leader>so :call te#utils#source_vimrc($MYVIMRC)<cr>
"open the vimrc in tab
nnoremap  <silent><leader>vc :call te#feat#edit_config()<cr>
"open quickfix windows
nnoremap  <silent><leader>qf :silent! botright copen<cr>
"open location windows
nnoremap  <silent><leader>qc q:
nnoremap  <silent><leader>q/ q/

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
nnoremap <silent><leader>fc :call te#utils#goto_cur_file(2)<cr> 
nnoremap <silent> <c-F7> :call te#utils#goto_cur_file(2)<cr> 

nnoremap <F7> :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" dos to unix or unix to dos
nnoremap  <silent><Leader>td :call te#utils#OptionToggle('ff',['dos', 'unix'])<cr>
" open url on cursor with default browser
nnoremap  <silent><leader>ol :call te#utils#open_url("")<cr>
" linu number toggle
nnoremap  <silent><Leader>tn :call te#utils#nu_toggle()<cr>
" realtime underline word toggle
nnoremap  <silent><leader>th :call te#utils#OptionToggle("g:cursorword",[0,1])<cr>

" next buffer or tab
nnoremap  <silent><tab> :call te#utils#tab_buf_switch(-1)<cr>
" next buffer or tab
nnoremap  <silent><Leader>bn :call te#utils#tab_buf_switch(-1)<cr>
" previous buffer or tab
nnoremap  <silent><Leader>bp :call te#utils#tab_buf_switch(0)<cr>
" delete buffer
nnoremap  <silent><Leader>bk :bdelete<cr>
"buffer only
nnoremap  <silent><leader>bo :call te#tools#buf_only('', '')<cr>
" save file
nnoremap  <silent><Leader>fs :call te#utils#SaveFiles()<cr>
" save all
nnoremap  <silent><Leader>fS :wa<cr>
" manpage or vimhelp on current curosr word
nnoremap  <silent><Leader>hm :call te#utils#find_mannel()<cr>
" open eval.txt
nnoremap  <silent><Leader>he :tabnew<cr>:h eval.txt<cr>:only<cr>
" open vim script help
nnoremap  <silent><Leader>hp :tabnew<cr>:h usr_41.txt<cr>:only<cr>
" open vim function list
nnoremap  <silent><Leader>hf :tabnew<cr>:h function-list<cr>:only<cr>

"update t_vim

nnoremap  <silent><Leader>ud :cd $VIMFILES<cr>:call te#utils#run_command('git fetch --all',function('te#tools#update_vinux'))<cr>
    

" quit all
nnoremap  <silent><Leader>qa :call te#utils#quit_win(1)<cr>
nnoremap  <silent><Leader>qq :call te#utils#quit_win(0)<cr>
" quit current tab
nnoremap  <silent><Leader>qw :tabclose<cr>
" quit all without save
nnoremap  <silent><Leader>qQ :qa!<cr>
" save and quit all
nnoremap  <silent><Leader>qs :wqa<cr>
" switch to last open tab or buffer
nnoremap  <silent><Leader><tab> :call te#utils#tab_buf_switch(-2)<cr>
" tab 1
nnoremap  <silent><leader>1 :call te#utils#tab_buf_switch(1)<cr>
" tab 2
nnoremap  <silent><leader>2 :call te#utils#tab_buf_switch(2)<cr>
" tab 3
nnoremap   <silent><leader>3 :call te#utils#tab_buf_switch(3)<cr>
" tab 4
nnoremap   <silent><leader>4 :call te#utils#tab_buf_switch(4)<cr>
" tab 5
nnoremap   <silent><leader>5 :call te#utils#tab_buf_switch(5)<cr>
" tab 6
nnoremap   <silent><leader>6 :call te#utils#tab_buf_switch(6)<cr>
" tab 7
nnoremap   <silent><leader>7 :call te#utils#tab_buf_switch(7)<cr>
" tab 8
nnoremap   <silent><leader>8 :call te#utils#tab_buf_switch(8)<cr>
" tab 9
nnoremap   <silent><leader>9 :call te#utils#tab_buf_switch(9)<cr>

"switch previous tab or buftab
nnoremap <silent> <Left> :call te#utils#tab_buf_switch(0)<cr>

"switch next tab or buftab
nnoremap <silent> <Right> :call te#utils#tab_buf_switch(-1)<cr>

"move
"nnoremap <Up> <C-b>
"nnoremap <Down> <C-f>

" vertical open window
nnoremap  <silent><Leader>wv :vsp<cr>
" vertical open window then focus the new one
nnoremap  <silent><Leader>wV :vsp<cr><C-w>l
" horizontal open window 
nnoremap  <silent><Leader>ws :sp<cr>
" horizontal open window then focus the new one
nnoremap  <silent><Leader>wS :sp<cr><C-w>j
" maxsize of current windows
nnoremap  <silent><Leader>wo :only<cr>
" quit current windows
nnoremap  <silent><Leader>wd :q<cr>
" switch between two windows alternately
nnoremap  <silent><Leader>w<tab> <C-w><C-p>
" switch between two windows.
nnoremap  <silent><Leader>ww <C-w><C-w>
" move to left win
nnoremap  <silent><Leader>wh <C-w>h
" move to right win
nnoremap  <silent><Leader>wl <C-w>l
" move down win
nnoremap  <silent><Leader>wj <C-w>j
" move up win
nnoremap  <silent><Leader>wk <C-w>k
" move to very left win
nnoremap  <silent><Leader>wH <C-w>H
" move to very right win
nnoremap  <silent><Leader>wL <C-w>L
" move to very down win
nnoremap  <silent><Leader>wJ <C-w>J
" move to very up win
nnoremap  <silent><Leader>wK <C-w>K
" rotate the window backward
nnoremap  <silent><Leader>wR <C-w>R
" rotate the window forward
nnoremap  <silent><Leader>wr <C-w>r
" Move the current window to a new tab page.
nnoremap  <silent><Leader>wt <C-w>T
" toggle focus coding
nnoremap  <silent><leader>tv :call te#utils#focus_coding()<cr>
" toggle paste option
" toggle paste option
nnoremap  <silent><leader>tp :call te#utils#OptionToggle("paste",[1,0])<cr>
" Toggle termguicolors
nnoremap  <silent><Leader>tl :call te#utils#OptionToggle('termguicolors',[1,0])<cr>
"textwidth between 0 and 80
nnoremap  <silent><Leader>tw :call te#utils#OptionToggle('textwidth',[80,0])<cr>
" cursorline toggle
nnoremap  <silent><Leader>tc :call te#utils#OptionToggle('cursorline',[1,0])<cr>
" feature enable
"nnoremap  <silent><Leader>fe :call te#feat#feat_dyn_enable(1)<cr>
nnoremap  <silent><Leader>fe :call te#feat#feat_dyn_enable(1)<cr>
nnoremap  <silent><Leader>fd :call te#feat#feat_dyn_enable(0)<cr>

" feature update
nnoremap  <silent><Leader>fu :call te#feat#gen_feature_vim(0)<cr>
" reset feature
nnoremap  <silent><Leader>fr :call te#feat#gen_feature_vim(1)<cr>

nnoremap  <silent><Leader>dj <c-u>
nnoremap  <silent><Leader>dd <c-d>
nnoremap <silent><Leader>pw :call te#utils#EchoWarning(getcwd(), 'info')<cr>
" cd to any plugin directory
nnoremap  <silent><Leader>cp :call te#utils#cd_to_plugin(g:vinux_plugin_dir.cur_val)<cr>
nnoremap <silent> <BS> <C-o>
"newtab
nnoremap  <silent><Leader>nt :tabnew<cr>

"generate tags and cscope
nnoremap  <silent><LocalLeader>u :call te#pg#gen_cs_out()<cr>

nnoremap  <silent><leader>wm :call te#tools#max_win()<cr>

"run command from input
nnoremap  <silent><leader>rc :call te#utils#run_command("", 1)<cr>
            
nmap s <Sop>
nnoremap sj za
vnoremap sf zf
nnoremap sk zM
nnoremap si zi

" close all buffer
nnoremap <silent><Leader>ba :call te#tools#buf_only(-1, '')<cr>
nnoremap  <silent><leader>jf :call te#terminal#jump_to_floating_win(-4)<cr>
nnoremap  <silent><leader>jt :call te#terminal#jump_to_floating_win(-3)<cr>
nnoremap  <silent><leader>j0 :call te#terminal#jump_to_floating_win(0)<cr>
nnoremap  <silent><leader>j1 :call te#terminal#jump_to_floating_win(1)<cr>
nnoremap  <silent><leader>j2 :call te#terminal#jump_to_floating_win(2)<cr>
nnoremap  <silent><leader>j3 :call te#terminal#jump_to_floating_win(3)<cr>
nnoremap  <silent><leader>j4 :call te#terminal#jump_to_floating_win(4)<cr>
nnoremap  <silent><leader>j5 :call te#terminal#jump_to_floating_win(5)<cr>
nnoremap  <silent><leader>j6 :call te#terminal#jump_to_floating_win(6)<cr>
nnoremap  <silent><leader>j7 :call te#terminal#jump_to_floating_win(7)<cr>
nnoremap  <silent><leader>j8 :call te#terminal#jump_to_floating_win(8)<cr>
nnoremap  <silent><leader>j9 :call te#terminal#jump_to_floating_win(9)<cr>
nnoremap  <silent><leader>rr :call te#terminal#start_ranger()<cr>
nnoremap  <silent><leader>rg :call te#terminal#shell_pop({'opener':0x2, 'cmd':'tig status'})<cr>
tnoremap <silent><Esc><Esc> <C-\><C-n>
tnoremap  <silent><c-w>q <C-\><C-n>:call te#terminal#hide_popup()<cr>

"previous terminal
tnoremap  <silent><c-w>p <C-\><C-n>:call te#terminal#jump_to_floating_win(-1)<cr>
"next terminal
tnoremap  <silent><c-w>n <C-\><C-n>:call te#terminal#jump_to_floating_win(-2)<cr>
tnoremap  <silent><c-w>w <C-\><C-n>:call te#terminal#jump_to_floating_win(-2)<cr>
"start fuzzy finder to select terminal
tnoremap  <silent><c-w><space> <C-\><C-n>:call te#terminal#jump_to_floating_win(-4)<cr>
"new terminal
tnoremap  <silent><c-w>a <C-\><C-n>:call te#terminal#jump_to_floating_win(-5)<cr>
"last open 
tnoremap  <silent><c-w><tab> <C-\><C-n>:call te#terminal#jump_to_floating_win(-3)<cr>
"rename terminal
tnoremap  <silent><c-w>r <C-\><C-n>:call te#terminal#rename()<cr>
"move terminal
tnoremap <silent><c-w>h <C-\><C-n>:call te#terminal#move_floating_win("left")<cr>
tnoremap <silent><c-w>l <C-\><C-n>:call te#terminal#move_floating_win("right")<cr>
tnoremap <silent><c-w>j <C-\><C-n>:call te#terminal#move_floating_win("bottom")<cr>
tnoremap <silent><c-w>k <C-\><C-n>:call te#terminal#move_floating_win("top")<cr>
tnoremap <silent><c-w>m <C-\><C-n>:call te#terminal#move_floating_win("middle")<cr>
tnoremap <silent><c-w>t <C-\><C-n>:call te#terminal#switch_opener({'opener':0x4})<cr>
tnoremap <silent><c-w>v <C-\><C-n>:call te#terminal#switch_opener({'opener':0x8})<cr>
tnoremap <silent><c-w>s <C-\><C-n>:call te#terminal#switch_opener({'opener':0x1})<cr>
tnoremap <silent><c-w>f <C-\><C-n>:call te#terminal#switch_opener({'opener':0x2})<cr>
command! -nargs=* -range T call te#terminal#send(<range>, <line1>, <line2>, <q-args>)
vnoremap <silent><leader>tr :T<cr>
nnoremap <silent><leader>re :call te#terminal#repl()<cr>
nnoremap <silent><leader>tr :execute line(".")."T"<cr>
nnoremap <silent><leader>ta :1,$T<cr>
if te#env#IsNvim() != 0
    tnoremap  <silent><c-w>d <C-\><C-n>:call te#terminal#hide_all()<cr>
    nnoremap <silent><c-w>d :call te#terminal#hide_all()<cr>
    "terminal-emulator setting
    execute 'tnoremap <A-h> <C-\><C-n>G<C-w>h'
    execute 'tnoremap <A-j> <C-\><C-n>G<C-w>j'
    execute 'tnoremap <A-k> <C-\><C-n>G<C-w>k'
    execute 'tnoremap <A-l> <C-\><C-n>G<C-w>l'
    silent! execute 'tmap <c-v> <C-\><C-n>"*pa'
elseif te#env#SupportTerminal()
    "terminal-emulator setting
    "execute 'tnoremap <Esc> <C-\><C-n>' "effect <a-> key?
    call te#meta#map('tmap <silent> ','h',te#terminal#get_termwinkey().'h')
    call te#meta#map('tmap <silent> ','j',te#terminal#get_termwinkey().'j')
    call te#meta#map('tmap <silent> ','k',te#terminal#get_termwinkey().'k')
    call te#meta#map('tmap <silent> ','l',te#terminal#get_termwinkey().'l')
    silent! execute 'tnoremap <c-v> '.te#terminal#get_termwinkey().'"*'
    call te#meta#map('tnoremap <silent> ','b','<C-left>')
    call te#meta#map('tnoremap <silent> ','f','<C-right>')
endif

" Open plug status windows
nnoremap  <silent><Leader>ps :PlugStatus<cr>
" update plugin
nnoremap  <silent><Leader>pu :PlugUpdate<cr>
" list plugins
nnoremap  <silent><Leader>pl :silent! call te#plug#list()<cr>
"checkhealth
nnoremap <silent> <Leader>ch :call te#utils#check_health()<cr>
" Open vimshell or neovim's emulator in split window
noremap <silent> <F4> :call te#terminal#shell_pop({'opener':0x1})<cr>
nnoremap <silent> <Leader>as :call te#terminal#shell_pop({'opener':0x1})<cr>
" Open vimshell or neovim's emulator in vertical window
nnoremap <silent> <Leader>av :call te#terminal#shell_pop({'opener':0x8})<cr>
" Open vimshell or neovim's emulator in floating window
nnoremap <silent> <Leader>af :call te#terminal#shell_pop({'opener':0x2})<cr>
" Open vimshell or neovim's emulator in new tab
nnoremap <silent> <Leader>at :call te#terminal#shell_pop({'opener':0x4})<cr>

call te#meta#map('inoremap','u','<c-\><c-o>:call te#tools#PreviousCursor(6)<cr>')
call te#meta#map('inoremap','d','<c-\><c-o>:call te#tools#PreviousCursor(7)<cr>')
call te#meta#map('nnoremap','d',':call te#tools#PreviousCursor(7)<cr>')
call te#meta#map('nnoremap','u',':call te#tools#PreviousCursor(6)<cr>')
call te#meta#map('inoremap','m','<c-\><c-o>:call te#tools#PreviousCursor(0)<cr>')
call te#meta#map('inoremap','n','<c-\><c-o>:call te#tools#PreviousCursor(1)<cr>')
call te#meta#map('nnoremap','m',':call te#tools#PreviousCursor(0)<cr>')
call te#meta#map('nnoremap','n',':call te#tools#PreviousCursor(1)<cr>')

nnoremap <silent><C-\>g :call te#complete#goto_def("sp")<cr>
nnoremap <silent><LocalLeader>g :call te#complete#goto_def("")<cr>

nnoremap <silent><LocalLeader>c :call te#complete#lookup_reference("")<cr>
nnoremap <silent><c-\>c :call te#complete#lookup_reference("sp")<cr>

nnoremap  <silent> <silent> KK :call te#utils#find_mannel()<cr>

nnoremap <expr><silent> <Enter> &buftype ==# 'quickfix' ? "\<CR>" : ":call te#complete#goto_def(\"\")\<cr>"
