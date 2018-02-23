"avoid source twice
if exists("b:did_vinux_ftplugin") 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal smarttab
setlocal tabstop=8
setlocal softtabstop=0
setlocal noexpandtab
setlocal shiftwidth=8
