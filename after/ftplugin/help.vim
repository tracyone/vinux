"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1
setlocal colorcolumn=

function! s:find_help_tag() abort
    let l:cur_line = line(".")
    let l:cur_file_name = expand('%:t')
    let l:cur_word = expand('<cWORD>')
    if &ft ==# 'help'
        if  l:cur_word[0] == '|'
            let l:cur_word = matchstr(l:cur_word, '\zs[^|].*\ze|')
        endif
    endif
    silent! execute ':tjump '.l:cur_word
    if l:cur_file_name == expand('%:t') && l:cur_line == line(".")
        call te#utils#EchoWarning("Can not find any tags")
    endif
endfunction

nnoremap  <silent><buffer> <down> <c-d>
nnoremap  <silent><buffer> <up> <c-u>
nnoremap  <silent><buffer> q :bdelete<cr>
nnoremap  <silent><buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
nnoremap  <silent><buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
nnoremap  <silent><buffer> ]g :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
nnoremap  <silent><buffer> [g F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
nnoremap  <silent><buffer> <cr> :call <SID>find_help_tag()<cr>
nnoremap  <silent><buffer> <bs> <c-T>
