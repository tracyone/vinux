"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal foldmethod=syntax
nmap <buffer> <localleader>wc <Plug>Vimwiki2HTML
