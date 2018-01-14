"avoid source twice
if exists("b:did_vinux_ftplugin") 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix

nnoremap <buffer><silent> <Enter> :call te#complete#goto_def("")<cr>

"sudo pip3 install yapf
if te#env#Executable('yapf')
    nnoremap <buffer><leader>cf :0,$!yapf<CR>
    vnoremap <buffer><leader>cf :!yapf<CR>
endif
