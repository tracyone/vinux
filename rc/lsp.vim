if te#env#IsNvim() >= 0.5
    Plug 'neovim/nvim-lspconfig', {'on': []}
    Plug 'williamboman/mason-lspconfig.nvim', {'on': []}
    Plug 'folke/trouble.nvim', {'on': []}
    Plug 'ray-x/lsp_signature.nvim', {'on': []}
    Plug 'onsails/lspkind.nvim', {'on': []}
    Plug 'nvimtools/none-ls.nvim', {'on': []}
    Plug 'jay-babu/mason-null-ls.nvim', {'on': []}
    call te#feat#register_vim_enter_setting2(['call te#feat#load_lua_modlue("nvim_lsp")'],
                \ ['nvim-lspconfig',  'mason-lspconfig.nvim', 'trouble.nvim'
                \ ,'lsp_signature.nvim', 'lspkind.nvim', 'none-ls.nvim', 'mason-null-ls.nvim'
                \ ,'mason-null-ls.nvim'])
elseif g:complete_plugin_type.cur_val ==# 'coc.nvim'

else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings',{'on': []}
    call te#feat#register_vim_enter_setting2([0], ['vim-lsp-settings'])
    if te#env#SupportFloatingWindows()
        let g:lsp_work_done_progress_enabled = 1
        let g:lsp_diagnostics_float_cursor = 1
        if te#env#IsVim() >= 900
            let g:lsp_diagnostics_virtual_text_enabled = 1
            let g:lsp_diagnostics_virtual_text_align = 'after'
        endif
        if has('patch-8.2.4780')
            let g:lsp_use_native_client = 1
        endif
        let g:lsp_diagnostics_signs_error = {'text': g:vinux_diagnostics_signs_error}
        let g:lsp_diagnostics_signs_warning = {'text': g:vinux_diagnostics_signs_warning}
        let g:lsp_diagnostics_signs_hint = {'text': g:vinux_diagnostics_signs_hint}
        augroup lsp_install
            au!
            autocmd User lsp_buffer_enabled :let g:vista_default_executive="vim_lsp"
            autocmd User lsp_float_opened call popup_setoptions(lsp#ui#vim#output#getpreviewwinid(), 
                        \ {'borderchars':['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                        \ 'borderhighlight':['vinux_border'],
                        \ 'highlight':'Pmenu'
                        \ })
        augroup END
    else
        let g:lsp_diagnostics_echo_cursor = 1
    endif
endif

"lsp setting
nnoremap  <silent> <silent> K :call te#lsp#hover()<cr>
nnoremap  <silent><Leader>lr  :call te#lsp#rename()<cr>
nnoremap  <silent><Leader>lc  :call te#lsp#code_action()<cr>
nnoremap  <silent><leader>ql :call te#lsp#show_diagnostics(0)<cr>
vnoremap  <silent><Leader>lf  :<C-u>call te#lsp#format_document_range()<cr>
nnoremap  <silent><Leader>lf  :call te#lsp#format_document()<cr>
nnoremap  <silent><Leader>li  :call te#lsp#find_implementation()<cr>
nnoremap  <silent><Leader>ly  :call te#lsp#goto_type_def()<cr>
nnoremap  <silent><Leader>lti  :call te#lsp#call_tree(1)<cr>
nnoremap  <silent><Leader>lto  :call te#lsp#call_tree(0)<cr>
nnoremap <silent> [d :call te#lsp#diagnostics_jump(0)<cr>
nnoremap <silent> ]d :call te#lsp#diagnostics_jump(1)<cr>
nnoremap  <silent><Leader>ll :call te#lsp#code_len()<cr>
nnoremap  <silent><Leader>ls  :call te#lsp#install_server()<cr>


