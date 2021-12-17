if te#env#IsNvim() >= 0.5
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'folke/trouble.nvim'
    function! s:lsp_setup()
lua << EOF
        require('nvim_lsp')
EOF
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>lsp_setup'))
else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings',{'on': []}
    nnoremap  <silent><leader>ql :call te#lsp#show_diagnostics(0)<cr>
    call te#feat#register_vim_enter_setting2([0], ['vim-lsp-settings'])
endif
"lsp setting
vnoremap  <silent><Leader>df :call te#lsp#format_document_range()<CR>
nnoremap  <silent> <silent> K :call te#lsp#hover()<cr>
nnoremap  <silent><Leader>rn  :call te#lsp#rename()<cr>

