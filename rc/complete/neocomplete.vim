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
