"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim
unlet! b:did_ftplugin
let b:undo_ftplugin = 'setl cms< com< fo<'
let b:did_ftplugin = 1
setlocal nospell 
setlocal conceallevel=2 
setlocal autoindent
setlocal textwidth=0
setlocal tabstop=4  
setlocal shiftwidth=4 
setlocal softtabstop=4 
setlocal expandtab
setlocal smarttab

if te#env#IsNvim() >= 0.5
    nnoremap  <silent><buffer> <leader>tt :Vista toc<cr>
else
    nnoremap  <silent><buffer> <leader>tt :Toc<cr>
endif
