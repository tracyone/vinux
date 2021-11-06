Plug 'liuchengxu/vista.vim'
if te#env#IsNvim() >= 0.5
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall', {'branch': 'main' }
    function! s:lsp_setup()
lua << EOF
        require('nvim_lsp')
EOF
    endfunction
    if g:fuzzysearcher_plugin_name.cur_val == 'fzf'
        nnoremap  <silent><c-k>  :Vista finder nvim_lsp<cr>
    endif
    call te#feat#register_vim_enter_setting(function('<SID>lsp_setup'))
else
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    if g:fuzzysearcher_plugin_name.cur_val == 'fzf'
        nnoremap  <silent><c-k>  :Vista finder vim_lsp<cr>
    endif
    nnoremap  <silent><leader>ql :LspDocumentDiagnostics<cr>
endif

function! s:vista_setup()
    " How each level is indented and what to prepend.
    " This could make the display more compact or more spacious.
    " e.g., more compact: ["▸ ", ""]
    " Note: this option only works for the kind renderer, not the tree renderer.
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

    " Executive used when opening vista sidebar without specifying it.
    " See all the avaliable executives via `:echo g:vista#executives`.
    let g:vista_default_executive = 'ctags'

    " Set the executive for some filetypes explicitly. Use the explicit executive
    " instead of the default one for these filetypes when using `:Vista` without
    " specifying the executive.
    let g:vista_executive_for = {
                \ 'cpp': 'vim_lsp',
                \ 'php': 'vim_lsp',
                \ }

    " Declare the command including the executable and options used to generate ctags output
    " for some certain filetypes.The file path will be appened to your custom command.
    " For example:
    let g:vista_ctags_cmd = {
                \ 'haskell': 'hasktags -x -o - -c',
                \ }

    " To enable fzf's preview window set g:vista_fzf_preview.
    " The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
    " For example:
    let g:vista_fzf_preview = ['right:50%']
    " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
    let g:vista#renderer#enable_icon = 0

    " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
    let g:vista#renderer#icons = {
                \   "function": "\uf794",
                \   "variable": "\uf71b",
                \  }

endfunction

call te#feat#register_vim_enter_setting(function('<SID>vista_setup'))
"lsp setting
vnoremap  <silent><Leader>df :call te#lsp#format_document_range()<CR>
nnoremap  <silent> <silent> K :call te#lsp#hover()<cr>
nnoremap  <silent><Leader>rn  :call te#lsp#rename()<cr>
