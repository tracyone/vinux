if te#env#SupportPy()
    Plug 'ashisha/image.vim'
endif
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'arecarn/selection.vim' | Plug 'arecarn/crunch.vim',{'on':'Crunch'}
Plug 'ianva/vim-youdao-translater', {'do': 'pip install requests --user','on': ['Ydc','Ydv']}
Plug 'vim-scripts/DrawIt',{'on': 'DrawIt'}
Plug 'mbbill/VimExplorer',{'on': 'VE'}
Plug 'vim-scripts/renamer.vim',{'on': 'Ren'}
Plug 'Shougo/vinarise.vim',{'on': 'Vinarise'}
Plug 'tracyone/hex2ascii.vim', { 'do': 'make' }
Plug 'justinmk/vim-gtfo' "got to file explorer or terminal
Plug 'adah1972/fencview',{'on': 'FencManualEncoding'}
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'vimwiki/vimwiki'

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
" vim calculator
nnoremap <Leader>ac :Crunch<cr>
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
" open calendar
nnoremap <Leader>ad :Calendar<cr>
" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
map <localleader>wt <Plug>VimwikiToggleListItem
nmap <localleader>wT <Plug>VimwikiTabIndex
nmap <localleader>ww <Plug>VimwikiIndex
nmap <localleader>wl <Plug>VimwikiUISelect
nmap <localleader>wi <Plug>VimwikiDiaryIndex
nmap <localleader>wd <Plug>VimwikiMakeDiaryNote
nmap <localleader>ii 0i* [ ] 
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
