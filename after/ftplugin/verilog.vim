"avoid source twice
if exists("b:did_vinux_ftplugin") 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal tabstop=3 
setlocal shiftwidth=3 
setlocal softtabstop=3 
setlocal expandtab
setlocal foldmarker=begin,end 
setlocal foldmethod=marker 
