Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim', {'for': 'vim'}
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

autocmd filetype_group FileType vim setlocal omnifunc=te#complete#vim_complete

nnoremap <Leader>vd :call te#tools#vim_get_message()<cr>
nnoremap <Leader>sm :message<cr>
