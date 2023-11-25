
nnoremap  <silent><buffer> <tab> :call search('(\d)', 'w')<cr>:noh<cr>2l
if te#env#IsNvim() != 0
    if g:outline_plugin.cur_val == 'tagbar' || g:outline_plugin.cur_val == 'vim-taglist'
        nnoremap  <silent><buffer><leader>tt  :lua require'man'.show_toc()<CR>
    endif
    nnoremap <buffer> <silent> <cr> <c-]>
else
    nnoremap <buffer> <silent> <cr> :call dist#man#PreGetPage(v:count)<CR>
endif
