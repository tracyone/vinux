if g:complete_plugin_type ==# 'deoplete'  && !te#env#IsNvim()
    let g:complete_plugin_type = 'ycm'
endif

if g:complete_plugin_type ==# 'ycm' 
    if te#env#IsUnix()
        Plug 'Valloric/YouCompleteMe', { 'on': [] }
        let g:complete_plugin_type_name='YouCompleteMe'
    elseif te#env#IsWin32()
        Plug 'snakeleon/YouCompleteMe-x86', { 'on': [] }
        let g:complete_plugin_type_name='YouCompleteMe-x86'
    else
        Plug 'snakeleon/YouCompleteMe-x64', { 'on': [] }
        let g:complete_plugin_type_name='YouCompleteMe-x64'
    endif
elseif g:complete_plugin_type ==# 'clang_complete'
    Plug 'Rip-Rip/clang_complete'
elseif g:complete_plugin_type ==# 'completor.vim'
    Plug 'maralla/completor.vim'
elseif g:complete_plugin_type ==# 'neocomplete' 
    Plug 'Shougo/neocomplete'
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
elseif g:complete_plugin_type ==# 'deoplete' 
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
else
    call te#utils#EchoWarning('No complete plugin selected!')
endif

" Complete ------------------------{{{
"generate .ycm_extra_conf.py for current directory

" lazyload ultisnips and YouCompleteMe
if g:complete_plugin_type ==# 'ycm'
    Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'tracyone/snippets'
    augroup lazy_load_group
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips',g:complete_plugin_type_name)
                    \| call delete('.ycm_extra_conf.pyc')  | call youcompleteme#Enable() 
                    \| autocmd! lazy_load_group
    augroup END
else
    Plug 'SirVer/ultisnips'
endif

" autoclose preview windows
autocmd misc_group InsertLeave * if pumvisible() == 0|pclose|endif

if g:complete_plugin_type ==# 'ycm'
    " jume to definition (YCM)
    nnoremap <leader>jl :YcmCompleter GoToDeclaration<CR>
    let g:ycm_confirm_extra_conf=0
    let g:syntastic_always_populate_loc_list = 1
    let g:ycm_semantic_triggers = {
                \   'c' : ['->', '    ', '.', ' ', '(', '[', '&'],
                \     'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
                \     'perl' : ['->', '::', ' '],
                \     'php' : ['->', '::', '.'],
                \     'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
                \     'ruby' : ['.', '::'],
                \     'lua' : ['.', ':'],
                \     'vim' : ['$', '&', 're![\w&$<-][\w:#<>-]*']
                \ }

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
    let g:ycm_global_ycm_extra_conf = $VIMFILES . '/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
elseif g:complete_plugin_type ==# 'neocomplete'
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
                \ 'cpp' : $VIMFILES.'/bundle/dict/cpp.dict',
                \ 'html' : $VIMFILES.'/bundle/dict/html.dict',
                \ 'c' : $VIMFILES.'/bundle/dict/c.dict',
                \ 'sh' : $VIMFILES.'/bundle/dict/bash.dict',
                \ 'dosbatch' : $VIMFILES.'/bundle/dict/batch.dict',
                \ 'tex' : $VIMFILES.'/bundle/dict/latex.dict',
                \ 'vim' : $VIMFILES.'/bundle/dict/vim.dict.txt',
                \ 'verilog' : $VIMFILES.'/bundle/dict/verilog.dict'
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
 elseif g:complete_plugin_type ==# 'clang_complete'
     " clang_complete
     " path to directory where library can be found
     if te#env#IsMac()
         let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
     elseif te#env#IsUnix()
         let g:clang_library_path='/usr/local/lib'
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
elseif g:complete_plugin_type ==# 'completor.vim'
    "completor.vim 
    let g:completor_clang_binary = '/usr/bin/clang'
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
elseif g:complete_plugin_type ==# 'deoplete'
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
endif
"}}}
" UltiSnips -----------------------{{{
if  te#env#SupportPy()
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsListSnippets ='<c-tab>'
let g:UltiSnipsJumpForwardTrigge='<c-j>'
let g:UltiSnipsJumpBackwardTrigge='<c-k>'
let g:UltiSnipsSnippetDirectories=['bundle/snippets']
let g:UltiSnipsSnippetsDir=$VIMFILES.'/bundle/snippets'
"}}}
