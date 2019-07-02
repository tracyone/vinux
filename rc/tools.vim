if te#env#SupportPy2() && te#env#IsLinux()
    Plug 'ashisha/image.vim'
endif
if te#env#SupportPy3()
    Plug 'fedorenchik/VimCalc3',{'on': 'Calc'}
    " vim calculator
    nnoremap <Leader>ac :Calc<cr>
elseif te#env#SupportPy2()
    Plug 'tracyone/VimCalc',{'on': 'Calc'}
    " vim calculator
    nnoremap <Leader>ac :Calc<cr>
else
    Plug 'arecarn/selection.vim' | Plug 'arecarn/vim-crunch',{'on':'Crunch'}
    " vim calculator
    nnoremap <Leader>ac :Crunch<cr>
endif
Plug 'sk1418/HowMuch',{'on': 'HowMuch'}
xnoremap <Leader>ac :<C-u>HowMuch =<cr>
xnoremap <Leader>ar :<C-u>HowMuch r<cr>
let g:HowMuch_scale = 16
let g:HowMuch_auto_engines = ['py', 'vim', 'bc']
Plug 'voldikss/vim-translate-me', {'on': ['TranslateW','TranslateR', 'Translate']}
command! -nargs=? Trans call te#trans#translate(<q-args>)
command! -nargs=? -range TransR call te#trans#replace(<q-args>)
Plug 'vim-scripts/DrawIt',{'on': 'DrawIt'}
if te#env#IsNvim() && te#env#SupportPy3()
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
    " Open Vim File Explorer
    nnoremap <Leader>fj :Defx -toggle -split=vertical -winwidth=50 -direction=topleft<cr>
    noremap <F12> :Defx -toggle -split=vertical -winwidth=50 -direction=topleft<cr>
    " Open nerd tree
    nnoremap <leader>te :Defx -toggle -split=vertical -winwidth=50 -direction=topleft<cr>
    " Open nerd tree
    nnoremap <leader>nf :Defx -toggle -split=vertical -winwidth=50 -direction=topleft `expand('%:p:h')` -search=`expand('%:p')`<CR> 
else
    Plug 'mbbill/VimExplorer',{'on': 'VE'}
    " Open Vim File Explorer
    nnoremap <Leader>fj :silent! VE .<cr>
endif
Plug 'qpkorr/vim-renamer',{'on': 'Ren'}
Plug 'Shougo/vinarise.vim',{'on': 'Vinarise'}
Plug 'will133/vim-dirdiff',{'on': 'DirDiff'}
if te#env#IsDisplay()
    Plug 'justinmk/vim-gtfo' "got to file explorer or terminal
endif
Plug 'adah1972/fencview',{'on': 'FencManualEncoding'}
if te#env#IsMac()
    Plug 'itchyny/dictionary.vim',{'on': 'Dictionary'}
endif

" FencView ------------------------{{{
let g:fencview_autodetect=0 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
function! FencToggle()
    if &fileencoding ==# 'utf-8'
        FencManualEncoding cp936
        call te#utils#EchoWarning('Chang encode to cp936')
    elseif &fileencoding ==# 'cp936'
        FencManualEncoding utf-8
        call te#utils#EchoWarning('Chang encode to utf-8')
    else
        call te#utils#EchoWarning('Current file encoding is '.&fileencoding)
    endif
endfunction
" Convert file's encode
nnoremap <leader>tf :call FencToggle()<cr>
"}}}
" YouDao translate
nnoremap <Leader>az :Trans en:zh-CN<cr>
" YouDao translate (visual mode)
vnoremap <Leader>az :TransR en:zh-CN<cr>
" YouDao translate
nnoremap <Leader>ae :Trans zh-CN:en<cr>
" YouDao translate (visual mode)
vnoremap <Leader>ae :TransR zh-CN:en<cr>
nnoremap <F10> <esc>:TranslateW<cr>
vmap <F10> <Plug>TranslateWV
" YouDao translate
nnoremap <silent><Leader>ay <esc>:TranslateW<cr>
" YouDao translate (visual mode)
vnoremap <silent><Leader>ay <Plug>TranslateWV
" open current file's position with default file explorer
nmap <Leader>af gof
" open current file's position with default terminal
nmap <Leader>at got
" open project's(pwd) position with default file explorer
nmap <Leader>aF goF
" open project's(pwd) position with default terminal
nmap <Leader>aT goT
function! s:drawit_toggle()
    let l:ret = te#utils#GetError('DrawIt','already on')
    if l:ret != 0
        :DIstop
    else
        call te#utils#EchoWarning('Started DrawIt')
    endif
endfunction
" draw it
nnoremap <leader>aw :call <SID>drawit_toggle()<cr>
" VimExplorer ---------------------{{{
let g:VEConf_systemEncoding = 'cp936'
noremap <F11> :silent! VE .<cr>
"}}}
" Renamer -------------------------{{{
noremap <F2> :Ren<cr>
"rename multi file name
nnoremap <Leader>fR :Ren<cr>
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
