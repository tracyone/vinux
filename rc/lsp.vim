if te#env#IsNvim() >= 0.5
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'folke/trouble.nvim'
    Plug 'ray-x/lsp_signature.nvim'
    function! s:lsp_setup()
lua << EOF
        require('nvim_lsp')
EOF
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>lsp_setup'))
elseif g:complete_plugin_type.cur_val ==# 'coc.nvim'

else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings',{'on': []}
    call te#feat#register_vim_enter_setting2([0], ['vim-lsp-settings'])
    if te#env#SupportFloatingWindows()
        let g:lsp_work_done_progress_enabled = 1
        let g:lsp_diagnostics_float_cursor = 1
        if te#env#IsVim9()
            let g:lsp_diagnostics_virtual_text_enabled = 1
        endif
        if has('patch-8.2.4780')
            let g:lsp_use_native_client = 1
        endif
        autocmd User lsp_float_opened call popup_setoptions(lsp#ui#vim#output#getpreviewwinid(), 
                    \ {'borderchars':['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                    \ 'borderhighlight':['vinux_border'],
                    \ 'highlight':'Pmenu'
                    \ })
    else
        let g:lsp_diagnostics_echo_cursor = 1
    endif
endif

"lsp setting
nnoremap  <silent> <silent> K :call te#lsp#hover()<cr>
nnoremap  <silent><Leader>lr  :call te#lsp#rename()<cr>
nnoremap  <silent><Leader>lc  :call te#lsp#code_action()<cr>
nnoremap  <silent><leader>ql :call te#lsp#show_diagnostics(0)<cr>
vnoremap  <silent><Leader>lf  :call te#lsp#format_document_range()<cr>
nnoremap  <silent><Leader>lf  :call te#lsp#format_document()<cr>
nnoremap  <silent><Leader>li  :call te#lsp#find_implementation()<cr>
nnoremap  <silent><Leader>ly  :call te#lsp#goto_type_def()<cr>
nnoremap  <silent><Leader>lti  :call te#lsp#call_tree(1)<cr>
nnoremap  <silent><Leader>lto  :call te#lsp#call_tree(0)<cr>
nnoremap <silent> [d :call te#lsp#diagnostics_jump(0)<cr>
nnoremap <silent> ]d :call te#lsp#diagnostics_jump(1)<cr>
nnoremap  <silent><Leader>ll :call te#lsp#code_len()<cr>
nnoremap  <silent><Leader>ls  :call te#lsp#install_server()<cr>


