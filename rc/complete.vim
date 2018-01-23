let g:complete_plugin={}
let g:complete_plugin.name=[g:complete_plugin_type.cur_val]
let g:complete_plugin.enable_func=function('te#env#IsVim8')
if g:complete_plugin_type.cur_val ==# 'YouCompleteMe' && te#env#SupportYcm()
    if te#env#IsUnix()
        Plug 'Valloric/YouCompleteMe', { 'on': [], 'commit': '32f1eae9cb8b8c7793f632fd24b2289839bf768e' }
        let g:complete_plugin.name=['YouCompleteMe']
    elseif te#env#IsWin32()
        Plug 'snakeleon/YouCompleteMe-x86', { 'on': [] }
        let g:complete_plugin.name=['YouCompleteMe-x86']
    else
        Plug 'snakeleon/YouCompleteMe-x64', { 'on': [] }
        let g:complete_plugin.name=['YouCompleteMe-x64']
    endif
    "Plug 'tenfyzhong/CompleteParameter.vim', { 'on': [] }
elseif g:complete_plugin_type.cur_val ==# 'clang_complete'
    Plug 'Rip-Rip/clang_complete', { 'on': [] }
elseif g:complete_plugin_type.cur_val ==# 'completor.vim' && te#env#IsVim8()
    Plug 'maralla/completor.vim'
elseif g:complete_plugin_type.cur_val ==# 'neocomplete' && te#env#SupportFeature('lua')
    Plug 'Shougo/neocomplete', { 'on': [] }
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
elseif g:complete_plugin_type.cur_val ==# 'deoplete.nvim'
    Plug 'Shougo/deoplete.nvim', { 'on': [] }
    Plug 'zchee/deoplete-clang',{'for':['c', 'cpp']}
    if !te#env#IsNvim()
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
else
    let g:complete_plugin_type.cur_val='supertab'
    let g:complete_plugin.name=["supertab"]
    Plug 'ervandew/supertab', { 'on': [] }
endif
Plug 'tracyone/snippets', { 'on': [] }
if te#env#SupportPy() && v:version >= 704
    Plug 'SirVer/ultisnips', { 'on': [] }  
    call extend(g:complete_plugin.name, ['ultisnips', 'snippets'])
else
    Plug 'MarcWeber/vim-addon-mw-utils', { 'on': [] } 
    Plug 'tomtom/tlib_vim', { 'on': [] } 
    Plug 'garbas/vim-snipmate', { 'on': [] } 
    call extend(g:complete_plugin.name, ['vim-addon-mw-utils', 'tlib_vim', 'vim-snipmate', 'snippets'])
    :imap <C-J> <Plug>snipMateNextOrTrigger
    :smap <C-J> <Plug>snipMateNextOrTrigger
    :imap <C-k> <Plug>snipMateBack
    :smap <C-k> <Plug>snipMateBack
endif

" Complete ------------------------{{{
"generate .ycm_extra_conf.py for current directory

" lazyload ultisnips and YouCompleteMe

if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
    " jume to definition (YCM)
    function! s:enable_ycm()
        call delete('.ycm_extra_conf.pyc')  | call youcompleteme#Enable() 
    endfunction
    let g:complete_plugin.enable_func=function('<SID>enable_ycm')
    nnoremap <leader>yj :YcmCompleter GoTo<CR>
    nnoremap <leader>yd :YcmDiags<cr>
    nnoremap <leader>yt :YcmCompleter GetType<cr>
    nnoremap <leader>yp :YcmCompleter GetParent<cr>
    nnoremap <leader>yf :YcmCompleter FixIt<cr>
    nnoremap <Leader>yu :call te#complete#update_ycm()<cr>
    "inoremap <silent><expr> ( complete_parameter#pre_complete("()")
    "smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    "imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    "smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    "imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    let g:ycm_key_detailed_diagnostics = '<leader>ys'
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_confirm_extra_conf=0
    let g:syntastic_always_populate_loc_list = 1
    let g:ycm_semantic_triggers = {
                \   'c' : ['->', '    ', '.', ' ', '(', '[', '&', 're!\w{4}'],
                \     'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
                \     'perl' : ['->', '::', ' '],
                \     'php' : ['->', '::', '.'],
                \     'cs,java,javascript,d,vim,perl6,scala,vb,elixir,go' : ['.'],
                \     'ruby' : ['.', '::'],
                \     'lua' : ['.', ':'],
                \     'vim' : ['$', '&', 're![\w&$<-][\w:#<>-]*']
                \ }
	let g:ycm_semantic_triggers.tex = [
				\ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
				\ ]
	let g:ycm_semantic_triggers.php = ['->', '::', '(', 'use ', 'namespace ', '\', '$', 're!\w{3}']
    let g:ycm_semantic_triggers.html = ['<', '"', '</', ' ']
    let g:ycm_semantic_triggers.python=['.', 'import ', 're!import [,\w ]+, ']
    let g:ycm_semantic_triggers.vimshell=['re!\w{2}', '/']
    let g:ycm_semantic_triggers.sh=['re![\w-]{2}', '/', '-', '$']
    let g:ycm_semantic_triggers.zsh=['re![\w-]{2}', '/', '-', '$']

    let g:ycm_collect_identifiers_from_tag_files = 1
    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'startufy' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1
                \}
    let g:ycm_global_ycm_extra_conf = g:vinux_plugin_dir.cur_val.'/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
elseif g:complete_plugin_type.cur_val ==# 'neocomplete'
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#data_directory = $VIMFILES . '/.neocomplete'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'cpp' : g:vinux_plugin_dir.cur_val.'/dict/cpp.dict',
                \ 'html' : g:vinux_plugin_dir.cur_val.'/dict/html.dict',
                \ 'c' : g:vinux_plugin_dir.cur_val.'/dict/c.dict',
                \ 'sh' : g:vinux_plugin_dir.cur_val.'/dict/bash.dict',
                \ 'dosbatch' : g:vinux_plugin_dir.cur_val.'/dict/batch.dict',
                \ 'tex' : g:vinux_plugin_dir.cur_val.'/dict/latex.dict',
                \ 'vim' : g:vinux_plugin_dir.cur_val.'/dict/vim.dict.txt',
                \ 'verilog' : g:vinux_plugin_dir.cur_val.'/dict/verilog.dict'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    "imap <expr> `  pumvisible() ? "\<Plug>(neocomplete_start_unite_quick_match)" : '`'
    " Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#sources#omni#input_patterns.php =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    " For smart TAB completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
           \ <SID>check_back_space() ? "\<TAB>" :
           \ neocomplete#start_manual_complete()
     function! s:check_back_space() 
       let col = col('.') - 1
       return !col || getline('.')[col - 1]  =~# '\s'
     endfunction
 elseif g:complete_plugin_type.cur_val ==# 'clang_complete'
     " clang_complete
     " path to directory where library can be found
     if te#env#IsMac()
         let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
     elseif te#env#IsUnix()
         let g:clang_library_path='/usr/local/lib'
     else
         let g:clang_library_path='c:/LLVM/bin'
     endif
     "let g:clang_use_library = 1
     let g:clang_complete_auto = 1
     let g:clang_debug = 1
     let g:clang_snippets=1
     let g:clang_complete_copen=0
     let g:clang_periodic_quickfix=1
     let g:clang_snippets_engine='ultisnips'
     let g:clang_close_preview=1
     "let g:clang_jumpto_declaration_key=""
     "g:clang_jumpto_declaration_in_preview_key
     inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
elseif g:complete_plugin_type.cur_val ==# 'completor.vim'
    "completor.vim 
    let g:completor_clang_binary = '/usr/bin/clang'
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
elseif g:complete_plugin_type.cur_val ==# 'deoplete.nvim'
    "deoplete
     if te#env#IsMac()
         let g:deoplete#sources#clang#libclang_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
         let g:deoplete#sources#clang#clang_header='/Library/Developer/CommandLineTools/usr/lib/clang/8.0.0/include/'
     elseif te#env#IsUnix()
         let g:deoplete#sources#clang#libclang_path='/usr/local/lib/libclang.so'
     endif
    let g:deoplete#enable_at_startup = 1
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
    let g:deoplete#sources#clang#flags=[]
    function! AddCFlags(dir)
        let l:dir=a:dir.'/'
        if strlen(a:dir) == 0
            let l:dir=getcwd().'/'
        endif
        if empty(glob(l:dir.'.clang_complete'))
           return 1 
        else
            for s:line in readfile(l:dir.'.clang_complete', '')
                :call add(g:deoplete#sources#clang#flags,matchstr(s:line,"\\v[^']+"))
            endfor
        endif
        return 0
    endfunction
    :call AddCFlags('')
    "let g:deoplete#omni#functions = {}
	"let g:deoplete#omni#functions.zsh = ['zsh_completion#Complete']
    "let g:deoplete#omni_patterns = {}
	"let g:deoplete#omni_patterns.zsh = '[^\t ]\+'
    "let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')
    "let g:deoplete#sources = {}
    "load all source
    "let g:deoplete#sources._ = []
else
    let g:SuperTabCrMapping = 0
    let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'
    function! Supertab_change_complete_type()
        if &omnifunc ==# '' && &completefunc ==# ''
            call SuperTabSetDefaultCompletionType("<c-p>")
        elseif &omnifunc !=# ''
            call SuperTabSetDefaultCompletionType("<c-x><c-o>")
            call SuperTabChain(&omnifunc, "<c-p>") |
        elseif &completefunc !=# ''
            call SuperTabSetDefaultCompletionType("<c-x><c-u>")
            call SuperTabChain(&completefunc, "<c-p>") |
        endif
    endfunction
    let g:complete_plugin.enable_func=function('Supertab_change_complete_type')
endif
call te#feat#register_vim_plug_insert_setting([g:complete_plugin.enable_func], 
            \ g:complete_plugin.name)

"}}}
" UltiSnips -----------------------{{{
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
let g:UltiSnipsSnippetsDir=g:vinux_plugin_dir.cur_val.'/snippets'
"}}}
