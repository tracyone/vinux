"settings....
setlocal fdm=marker 
setlocal expandtab 
setlocal tabstop=4 
setlocal shiftwidth=4 
setlocal softtabstop=4
setlocal smarttab
setlocal suffixesadd=.vim
setlocal iskeyword+=:,#

"keymapping...
nnoremap <buffer><silent> <c-]>  :call lookup#lookup()<cr>
nnoremap <buffer><silent> <c-t>  :call lookup#pop()<cr>
nnoremap <buffer><silent> <Enter> :call lookup#lookup()<cr>
