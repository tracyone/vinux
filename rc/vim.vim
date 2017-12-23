Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim', {'on':[]}
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

autocmd filetype_group FileType vim setlocal omnifunc=te#complete#vim_complete

call te#feat#register_vim_plug_insert_setting([], 
            \ ['neco-vim'])

nnoremap <Leader>vd :call te#tools#vim_get_message()<cr>
nnoremap <Leader>sm :message<cr>
