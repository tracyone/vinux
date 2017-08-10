if te#env#SupportPy2() && !te#env#IsWindows()
    Plug 'ashisha/image.vim'
endif
if te#env#SupportPy3()
    Plug 'fedorenchik/VimCalc3',{'on': 'Calc'}
    " vim calculator
    nnoremap <Leader>ac :Calc<cr>
elseif te#env#SupportPy2()
    Plug 'gregsexton/VimCalc',{'on': 'Calc'}
    " vim calculator
    nnoremap <Leader>ac :Calc<cr>
else
    Plug 'arecarn/selection.vim' | Plug 'arecarn/vim-crunch',{'on':'Crunch'}
    " vim calculator
    nnoremap <Leader>ac :Crunch<cr>
endif
Plug 'ianva/vim-youdao-translater', {'do': 'pip install requests --user','on': ['Ydc','Ydv']}
Plug 'vim-scripts/DrawIt',{'on': 'DrawIt'}
Plug 'mbbill/VimExplorer',{'on': 'VE'}
Plug 'qpkorr/vim-renamer',{'on': 'Ren'}
Plug 'Shougo/vinarise.vim',{'on': 'Vinarise'}
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
" YouDao translate
nnoremap <Leader>ay <esc>:Ydc<cr>
" YouDao translate (visual mode)
vnoremap <Leader>ay <esc>:Ydv<cr>
nnoremap <F10> <esc>:Ydc<cr>
vnoremap <F10> <esc>:Ydv<cr>
"hex to ascii convert
nnoremap <leader>ah :call Hex2asciiConvert()<cr>
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
" Open Vim File Explorer
nnoremap <Leader>fj :silent! VE .<cr>
"}}}
" Renamer -------------------------{{{
noremap <F2> :Ren<cr>
"rename multi file name
nnoremap <Leader>fR :Ren<cr>
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
