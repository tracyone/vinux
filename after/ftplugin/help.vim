"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal colorcolumn=

nnoremap  <silent><buffer> <down> <c-d>
nnoremap  <silent><buffer> <up> <c-u>
nnoremap  <silent><buffer> q :bdelete<cr>
nnoremap  <silent><buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
nnoremap  <silent><buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
nnoremap  <silent><buffer> ]g :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
nnoremap  <silent><buffer> [g F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
nnoremap  <silent><buffer> <cr> <c-]>
nnoremap  <silent><buffer> <bs> <c-T>
