if g:complete_plugin_type ==# 'deoplete'  && !te#env#IsNvim()
    let g:complete_plugin_type = 'ycm'
endif

if g:complete_plugin_type ==# 'ycm' && te#env#SupportYcm()
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
    Plug 'tenfyzhong/CompleteParameter.vim'
elseif g:complete_plugin_type ==# 'clang_complete'
    Plug 'Rip-Rip/clang_complete'
elseif g:complete_plugin_type ==# 'completor.vim' && te#env#IsVim8()
    Plug 'maralla/completor.vim'
elseif g:complete_plugin_type ==# 'neocomplete' && te#env#SupportFeature('lua')
    Plug 'Shougo/neocomplete'
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
elseif g:complete_plugin_type ==# 'deoplete'  && te#env#IsNvim()
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
else
    call te#utils#EchoWarning('No comlete plugin was selected!', 1)
    Plug 'ervandew/supertab'
    let g:complete_plugin_type=''
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

if g:complete_plugin_type ==# 'ycm'
    " jume to definition (YCM)
    nnoremap <leader>yj :YcmCompleter GoTo<CR>
    nnoremap <leader>yd :YcmDiags<cr>
    nnoremap <leader>yt :YcmCompleter GetType<cr>
    nnoremap <leader>yp :YcmCompleter GetParent<cr>
    nnoremap <leader>yf :YcmCompleter FixIt<cr>
    nnoremap <Leader>yu :call te#complete#update_ycm()<cr>
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
    let g:ycm_global_ycm_extra_conf = g:t_vim_plugin_install_path.'/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
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
                \ 'cpp' : g:t_vim_plugin_install_path.'/dict/cpp.dict',
                \ 'html' : g:t_vim_plugin_install_path.'/dict/html.dict',
                \ 'c' : g:t_vim_plugin_install_path.'/dict/c.dict',
                \ 'sh' : g:t_vim_plugin_install_path.'/dict/bash.dict',
                \ 'dosbatch' : g:t_vim_plugin_install_path.'/dict/batch.dict',
                \ 'tex' : g:t_vim_plugin_install_path.'/dict/latex.dict',
                \ 'vim' : g:t_vim_plugin_install_path.'/dict/vim.dict.txt',
                \ 'verilog' : g:t_vim_plugin_install_path.'/dict/verilog.dict'
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
if  te#env#SupportPy2()
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsListSnippets ='<c-tab>'
let g:UltiSnipsJumpForwardTrigge='<c-j>'
let g:UltiSnipsJumpBackwardTrigge='<c-k>'
let g:UltiSnipsSnippetDirectories=['bundle/snippets']
let g:UltiSnipsSnippetsDir=g:t_vim_plugin_install_path.'/snippets'
"}}}
