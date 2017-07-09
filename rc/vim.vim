Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim'
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

autocmd FileType vim setlocal omnifunc=te#complete#vim_complete
