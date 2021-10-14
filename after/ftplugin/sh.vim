"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1
"shell script
setlocal expandtab 
setlocal tabstop=4 
setlocal shiftwidth=4 
setlocal softtabstop=4
setlocal smarttab
setlocal foldmethod=indent
if get(g:, 'feat_enable_zsh') == 1 && matchstr(&shell,'zsh') !=# ''
    setlocal omnifunc=zsh_completion#Complete
else
    setlocal shell=bash
    setlocal omnifunc=te#bashcomplete#omnicomplete
endif
