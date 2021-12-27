"asyncomplete.vim config

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
if g:feat_enable_lsp == 1
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif
"Plug 'prabirshrestha/asyncomplete-ultisnips.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-necovim.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-file.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'on': [] }
Plug 'htlsne/asyncomplete-look', {'for': ['markdown', 'text', 'gitcommit', 'gina-commit']}
if te#env#SupportPy() && v:version >= 704
    Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
endif

function! s:asyncomplete_setup()
    call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
                \ 'name': 'necovim',
                \ 'whitelist': ['vim'],
                \ 'completor': function('asyncomplete#sources#necovim#completor'),
                \ }))
    call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                \ 'name': 'file',
                \ 'whitelist': ['*'],
                \ 'priority': 10,
                \ 'completor': function('asyncomplete#sources#file#completor')
                \ }))
    if te#env#SupportPy() && v:version >= 704
        call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                    \ 'name': 'ultisnips',
                    \ 'allowlist': ['*'],
                    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
                    \ }))
    endif
    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                \ 'name': 'buffer',
                \ 'whitelist': ['*'],
                \ 'blacklist': ['go'],
                \ 'completor': function('asyncomplete#sources#buffer#completor'),
                \ }))
    call asyncomplete#register_source({
                \ 'name': 'look',
                \ 'allowlist': ['text', 'markdown', 'gitcommit', 'gina-commit'],
                \ 'completor': function('asyncomplete#sources#look#completor'),
                \ })
    let g:asyncomplete_min_chars = 2
endfunction
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:complete_plugin.name = ['asyncomplete-necovim.vim', 'asyncomplete-file.vim'
            \ ,'asyncomplete-buffer.vim']
let g:complete_plugin.enable_func=function('<SID>asyncomplete_setup')
