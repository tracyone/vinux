let g:complete_plugin={}
let g:complete_plugin.name=[g:complete_plugin_type.cur_val]
let g:complete_plugin.enable_func=function('te#env#IsVim8')
if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
    if !te#env#SupportYcm()
        call te#utils#EchoWarning("python2 feature and patch-7.4.1578 are required to use YoucompleteMe")
        let g:complete_plugin_type.cur_val='supertab'
    else
        if te#env#IsUnix()
            Plug 'Valloric/YouCompleteMe', { 'on': [], 'commit': '85c11d3a875b02a7ac28fb96d0c7a02782f60410' }
            let g:complete_plugin.name=['YouCompleteMe']
        elseif te#env#IsWin32()
            Plug 'snakeleon/YouCompleteMe-x86', { 'on': [] }
            let g:complete_plugin.name=['YouCompleteMe-x86']
        else
            Plug 'snakeleon/YouCompleteMe-x64', { 'on': [] }
            let g:complete_plugin.name=['YouCompleteMe-x64']
        endif
        call te#feat#source_rc('complete/ycm.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'clang_complete'
    if !te#env#SupportPy()
        call te#utils#EchoWarning("python feature are required to use asyncomplete.vim")
        let g:complete_plugin_type.cur_val='supertab'
    else
        Plug 'xavierd/clang_complete', { 'on': [] }
        call te#feat#source_rc('complete/clang_complete.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'asyncomplete.vim'
    if !te#env#SupportAsync()
        call te#utils#EchoWarning("neovim or vim8 are required to use asyncomplete.vim")
        let g:complete_plugin_type.cur_val='supertab'
    else
        call te#feat#source_rc('complete/asyncomplete.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'neocomplete'
    if !te#env#SupportFeature('lua') || has('patch-8.2.1066')
        call te#utils#EchoWarning("lua feature and vim 8.2.1066- are required to use neocomplete.vim")
        let g:complete_plugin_type.cur_val='supertab'
    else
        Plug 'Shougo/neocomplete', { 'on': [] }
        Plug 'tracyone/dict'
        Plug 'Konfekt/FastFold'
        call te#feat#source_rc('complete/neocomplete.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'deoplete.nvim'
    if !te#env#SupportPy3() || !has('patch-8.2.1978')
        call te#utils#EchoWarning("python3 feature and vim 8.2.1978+ are required to use deoplete.nvim")
        let g:complete_plugin_type.cur_val='supertab'
    else
        call te#feat#source_rc('complete/deoplete.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'ncm2'
    if !te#env#SupportPy3() || !te#env#SupportAsync()
        call te#utils#EchoWarning("python3 feature and vim 8.2.1978+ are required to use ncm2")
        let g:complete_plugin_type.cur_val='supertab'
    else
        call te#feat#source_rc('complete/ncm2.vim')
    endif
elseif g:complete_plugin_type.cur_val ==# 'nvim-cmp'
    if te#env#IsNvim() == 0
        call te#utils#EchoWarning("lastest neovim are required to use nvim-cmp")
        let g:complete_plugin_type.cur_val='supertab'
    else
        Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main', 'on': [] }
        Plug 'hrsh7th/cmp-buffer', {'branch': 'main', 'on': [] }
        Plug 'hrsh7th/nvim-cmp', {'branch': 'main', 'on': [] }
        Plug 'hrsh7th/cmp-path', {'branch': 'main', 'on': [] }
        Plug 'hrsh7th/cmp-nvim-lua',{'branch': 'main', 'on': []}
        Plug 'hrsh7th/cmp-cmdline', {'on': []}
        Plug 'quangnguyen30192/cmp-nvim-ultisnips', {'branch': 'main', 'on': [] }
        Plug 'octaltree/cmp-look', { 'on': []}
        Plug 'hrsh7th/cmp-calc', { 'on': []}
        "Plug 'onsails/lspkind-nvim'
        "Plug 'tamago324/cmp-zsh',{'for':['bash','zsh'], 'branch': 'main'}

        function! s:enable_nvim_lsp()
            call te#feat#load_lua_modlue("nvim_cmp")
            autocmd FileType markdown,gitcommit,gina-commit lua require'cmp'.setup.buffer {
                        \   sources = {
                        \     {name='look', keyword_length=2},
                        \ { name = 'ultisnips' },
                        \ { name = 'buffer' },
                        \ { name = 'git' },
                        \   },
                        \ }
        endfunction
        "Important config neovim lsp and cmp when vim enter
        call te#feat#register_vim_enter_setting2([function('<SID>enable_nvim_lsp')],
                    \ ['cmp-nvim-lsp', 'nvim-cmp', 'cmp-path', 'cmp-buffer',
                    \ 'cmp-nvim-lua', 'cmp-cmdline', 'cmp-nvim-ultisnips', 'cmp-look', 'cmp-calc'])
    endif
elseif g:complete_plugin_type.cur_val ==# 'coc.nvim'
    if !te#env#Executable('node') || !te#env#SupportAsync()
        call te#utils#EchoWarning("nodejs 16 and vim8 or neovim are required to use coc.nvim")
        let g:complete_plugin_type.cur_val='supertab'
    else
        call te#feat#source_rc('complete/coc.vim')
    endif
endif



Plug 'tracyone/snippets', { 'on': [] }
if te#env#SupportPy() && v:version >= 704
    Plug 'SirVer/ultisnips', { 'on': [], 'tag': '3.2' }  
    call extend(g:complete_plugin.name, ['ultisnips', 'snippets'])
else
    Plug 'MarcWeber/vim-addon-mw-utils', { 'on': [] } 
    Plug 'tomtom/tlib_vim', { 'on': [] } 
    Plug 'garbas/vim-snipmate', { 'on': [] } 
    call extend(g:complete_plugin.name, ['vim-addon-mw-utils', 'tlib_vim', 'vim-snipmate', 'snippets'])
    :imap  <silent><C-J> <Plug>snipMateNextOrTrigger
    :smap  <silent><C-J> <Plug>snipMateNextOrTrigger
    :imap  <silent><C-k> <Plug>snipMateBack
    :smap  <silent><C-k> <Plug>snipMateBack
endif

if g:complete_plugin_type.cur_val ==# 'supertab'
    let g:complete_plugin.name=['supertab']
    Plug 'ervandew/supertab', { 'on': [] }
    let g:SuperTabCrMapping = 0
    let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'
    function! Supertab_change_complete_type()
        if &omnifunc ==# '' && &completefunc ==# ''
            call SuperTabSetDefaultCompletionType('<c-p>')
        elseif &omnifunc !=# ''
            call SuperTabSetDefaultCompletionType('<c-x><c-o>')
            call SuperTabChain(&omnifunc, '<c-p>') |
        elseif &completefunc !=# ''
            call SuperTabSetDefaultCompletionType('<c-x><c-u>')
            call SuperTabChain(&completefunc, '<c-p>') |
        endif
    endfunction
    let g:complete_plugin.enable_func=function('Supertab_change_complete_type')
endif

call te#feat#register_vim_plug_insert_setting([g:complete_plugin.enable_func], 
            \ g:complete_plugin.name)

" UltiSnips
if  te#env#SupportPy2()
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsListSnippets ='<c-tab>'
let g:UltiSnipsJumpForwardTrigge='<c-j>'
let g:UltiSnipsJumpBackwardTrigge='<c-k>'
let g:UltiSnipsSnippetDirectories=['bundle/snippets/ultisnips']
let g:UltiSnipsSnippetsDir=g:vinux_plugin_dir.cur_val.'/snippets/ultisnips'
