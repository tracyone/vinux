"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif

noremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR> 
noremap <buffer> <c-x> <C-w><Enter><C-w>K
nnoremap <buffer> q :ccl<cr>:lcl<cr>
nnoremap <buffer> o <CR><C-w>p
nnoremap <buffer> <c-j> <CR><C-w>p
nnoremap <buffer> <c-t> <C-w><CR><C-w>T
nnoremap <buffer> <c-v> <C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p
nnoremap <buffer> <c-o> :silent! colder<cr>:silent! :lolder<cr>
nnoremap <buffer> <c-i> :silent! cnewer<cr>:silent! :lnewer<cr>
execute 'nnoremap <buffer>  <2-LeftMouse> '. maparg('<Enter>')
