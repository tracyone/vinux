Plug 'Shougo/neco-vim'
Plug 'mhinz/vim-lookup', {'for': 'vim'}

autocmd! filetype_group BufWritePost,BufEnter *.vim Neomake
