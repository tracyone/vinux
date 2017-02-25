Plug 'Shougo/neco-vim'
Plug 'mhinz/vim-lookup', {'for': 'vim'}
"keymapping...
nnoremap <buffer><silent> <c-]>  :call lookup#lookup()<cr>
nnoremap <buffer><silent> <c-t>  :call lookup#pop()<cr>
