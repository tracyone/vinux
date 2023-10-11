if te#env#SupportPy2() && te#env#IsLinux()
    Plug 'ashisha/image.vim'
endif
if te#env#SupportPy3()
    Plug 'fedorenchik/VimCalc3',{'on': 'Calc'}
    Plug 'bujnlc8/vim-translator', {'on': ['Tc', 'Ti', 'Tv', 'Tz']}
    " vim calculator
    nnoremap  <silent><Leader>ac :Calc<cr>
elseif te#env#SupportPy2()
    Plug 'tracyone/VimCalc',{'on': 'Calc'}
    " vim calculator
    nnoremap  <silent><Leader>ac :Calc<cr>
else
    Plug 'arecarn/selection.vim' | Plug 'arecarn/vim-crunch',{'on':'Crunch'}
    " vim calculator
    nnoremap  <silent><Leader>ac :Crunch<cr>
endif
Plug 'sk1418/HowMuch',{'on': 'HowMuch'}
xnoremap  <silent><Leader>ac :<C-u>HowMuch =<cr>
xnoremap  <silent><Leader>ar :<C-u>HowMuch r<cr>
let g:HowMuch_scale = 16
let g:HowMuch_auto_engines = ['py', 'vim', 'bc']
Plug 'vim-scripts/DrawIt',{'on': 'DrawIt'}
Plug 'qpkorr/vim-renamer',{'on': 'Ren'}
Plug 'Shougo/vinarise.vim',{'on': 'Vinarise'}
Plug 'will133/vim-dirdiff',{'on': 'DirDiff'}
if te#env#IsDisplay()
    "got to file explorer or terminal
    Plug 'justinmk/vim-gtfo', {'on': []}
    call te#feat#register_vim_enter_setting2([0], ['vim-gtfo'])
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
nnoremap  <silent><leader>tf :call FencToggle()<cr>
"}}}
" translate
let g:translator_channel='baidu'
nnoremap  <silent><leader>az :<C-u>Tz<CR>
nnoremap  <silent><leader>ai :<C-u>Ti<CR>
nnoremap <silent><Leader>ay :<C-u>Tc<cr>
" translate (visual mode)
vnoremap <silent><Leader>ay :<C-u>Tv<cr>

" open current file's position with default file explorer
nmap  <silent><Leader>of gof
" open current file's position with default terminal
nmap  <silent><Leader>ot got
" open project's(pwd) position with default file explorer
nmap  <silent><Leader>oF goF
" open project's(pwd) position with default terminal
nmap  <silent><Leader>oT goT
function! s:drawit_toggle()
    let l:ret = te#utils#GetError('DrawIt','already on')
    if l:ret != 0
        :DIstop
    else
        call te#utils#EchoWarning('Started DrawIt')
    endif
endfunction
" draw it
nnoremap  <silent><leader>aw :call <SID>drawit_toggle()<cr>
"}}}
" Renamer -------------------------{{{
noremap  <silent><F2> :Ren<cr>
"rename multi file name
nnoremap  <silent><Leader>fR :Ren<cr>
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
