
runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim
unlet! b:did_ftplugin
let b:undo_ftplugin = 'setl cms< com< fo<'
let b:did_ftplugin = 1
setlocal nospell 
setlocal conceallevel=2 
setlocal autoindent
setlocal textwidth=0

nnoremap <buffer> <leader>tt :Toc<cr>
