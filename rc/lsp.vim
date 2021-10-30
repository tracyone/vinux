if te#env#IsNvim() >= 0.5
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall', {'branch': 'main' }
    function! s:lsp_setup()
lua << EOF
        require('nvim_lsp')
EOF
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>lsp_setup'))
else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    if executable('clangd')
        au misc_group User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
    endif
    if executable('pyls')
        " pip install python-language-server
        au misc_group User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': {server_info->['pyls']},
                    \ 'whitelist': ['python'],
                    \ })
    endif
    if executable('typescript-language-server')
        au misc_group User lsp_setup call lsp#register_server({
                    \ 'name': 'javascript support using typescript-language-server',
                    \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                    \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
                    \ 'whitelist': ['javascript', 'javascript.jsx']
                    \ })
    endif

endif

"lsp setting
vnoremap  <silent><Leader>df :call te#lsp#format_document_range()<CR>
nnoremap  <silent> <silent> K :call te#lsp#hover()<cr>
nnoremap  <silent><Leader>rn  :call te#lsp#rename()<cr>
