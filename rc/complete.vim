let g:complete_plugin={}
let g:complete_plugin.name=[g:complete_plugin_type.cur_val]
let g:complete_plugin.enable_func=function('te#env#IsVim8')
if g:complete_plugin_type.cur_val ==# 'YouCompleteMe' && te#env#SupportYcm()
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
elseif g:complete_plugin_type.cur_val ==# 'clang_complete'
    Plug 'xavierd/clang_complete', { 'on': [] }
    call te#feat#source_rc('complete/clang_complete.vim')
elseif g:complete_plugin_type.cur_val ==# 'asyncomplete.vim' && te#env#SupportAsync()
    call te#feat#source_rc('complete/asyncomplete.vim')
elseif g:complete_plugin_type.cur_val ==# 'neocomplete' && te#env#SupportFeature('lua')
    Plug 'Shougo/neocomplete', { 'on': [] }
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
    call te#feat#source_rc('complete/neocomplete.vim')
elseif g:complete_plugin_type.cur_val ==# 'deoplete.nvim'
    call te#feat#source_rc('complete/deoplete.vim')
elseif g:complete_plugin_type.cur_val ==# 'ncm2' && te#env#SupportPy3()
    call te#feat#source_rc('complete/ncm2.vim')
elseif g:complete_plugin_type.cur_val ==# 'nvim-cmp' && te#env#IsNvim() >= 0.5
    Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main' }
    Plug 'hrsh7th/cmp-buffer', {'branch': 'main' }
    Plug 'hrsh7th/nvim-cmp', {'branch': 'main' }
    Plug 'hrsh7th/cmp-path', {'branch': 'main' }
    Plug 'hrsh7th/cmp-nvim-lua',{'branch': 'main'}
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips', {'branch': 'main' }
    Plug 'octaltree/cmp-look'
    Plug 'hrsh7th/cmp-calc'
    "Plug 'onsails/lspkind-nvim'
    "Plug 'tamago324/cmp-zsh',{'for':['bash','zsh'], 'branch': 'main'}

function! s:enable_nvim_lsp()
lua << EOF
    require('nvim_cmp')
EOF
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
call te#feat#register_vim_enter_setting(function('<SID>enable_nvim_lsp'))
elseif g:complete_plugin_type.cur_val ==# 'coc.nvim'
    call te#feat#source_rc('complete/coc.vim')
else
    let g:complete_plugin_type.cur_val='supertab'
    let g:complete_plugin.name=['supertab']
    Plug 'ervandew/supertab', { 'on': [] }
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
