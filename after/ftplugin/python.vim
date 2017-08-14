setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix

nnoremap <buffer><silent> <Enter> :call te#complete#goto_def("")<cr>
