Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim'
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

autocmd FileType vim setlocal omnifunc=te#complete#vim_complete

nnoremap <Leader>vd :call te#tools#vim_get_message()<cr>
nnoremap <Leader>sm :message<cr>
