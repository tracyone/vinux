"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif

noremap  <silent><buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR> 
noremap  <silent><buffer> <c-x> <C-w><Enter><C-w>K
nnoremap  <silent><buffer> q :ccl<cr>:lcl<cr>
nnoremap  <silent><buffer> o <CR><C-w>p
nnoremap  <silent><buffer> <c-j> <CR><C-w>p
nnoremap  <silent><buffer> <c-t> <C-w><CR><C-w>T
nnoremap  <silent><buffer> <c-v> <C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p
nnoremap  <silent><buffer> <c-o> :silent! colder<cr>:silent! :lolder<cr>
nnoremap  <silent><buffer> <c-i> :silent! cnewer<cr>:silent! :lnewer<cr>
execute 'nnoremap  <silent><buffer>  <2-LeftMouse> '. maparg('<Enter>')
