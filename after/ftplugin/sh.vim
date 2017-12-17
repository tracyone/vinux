"shell script
setlocal expandtab 
setlocal tabstop=4 
setlocal shiftwidth=4 
setlocal softtabstop=4
setlocal smarttab
setlocal foldmethod=indent
if get(g:, "feat_enable_zsh") == 1 && matchstr(&shell,'zsh') !=# ''
    setlocal omnifunc=zsh_completion#Complete
else
    setlocal sh=bash
    setlocal omnifunc=te#bashcomplete#omnicomplete
endif
nnoremap <buffer> <silent> K :call te#utils#find_mannel()<cr>
