Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins', 'on': []}

function! s:config_deoplete()
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


    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ deoplete#manual_complete()
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

    inoremap <expr><C-g>       deoplete#refresh()
    inoremap <expr><C-e>       deoplete#cancel_popup()
    inoremap <silent><expr><C-l>       deoplete#complete_common_string()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
        return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
    endfunction

    " cpsm test
    " call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])
    " call deoplete#custom#source('_', 'sorters', [])

    call deoplete#custom#source('_', 'matchers',
                \ ['matcher_fuzzy', 'matcher_length'])
    call deoplete#custom#source('eskk,tabnine', 'matchers', [])
    " call deoplete#custom#source('buffer', 'mark', '')
    " call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
    " call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
    " call deoplete#custom#source('buffer', 'mark', '*')

    call deoplete#custom#source('look', 'filetypes', ['help', 'gitcommit'])
    call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer', 'tag']})

    call deoplete#custom#source('tabnine', 'rank', 300)
    call deoplete#custom#source('tabnine', 'min_pattern_length', 2)

    call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])

    call deoplete#custom#source('_', 'converters', [
                \ 'converter_remove_paren',
                \ 'converter_remove_overlap',
                \ 'matcher_length',
                \ 'converter_truncate_abbr',
                \ 'converter_truncate_menu',
                \ 'converter_auto_delimiter',
                \ ])
    call deoplete#custom#source('tabnine', 'converters', [
                \ 'converter_remove_overlap',
                \ ])
    call deoplete#custom#source('eskk', 'converters', [])

    " call deoplete#custom#source('buffer', 'min_pattern_length', 9999)
    " call deoplete#custom#source('clang', 'input_pattern', '\.\w*|\.->\w*|\w+::\w*')
    " call deoplete#custom#source('clang', 'max_pattern_length', -1)

    call deoplete#custom#option('keyword_patterns', {
                \ '_': '[a-zA-Z_]\k*\(?',
                \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
                \ })

    " inoremap <silent><expr> <C-t> deoplete#manual_complete('file')

    call deoplete#custom#option({
                \ 'auto_refresh_delay': 10,
                \ 'camel_case': v:true,
                \ 'skip_multibyte': v:true,
                \ 'prev_completion_mode': 'mirror',
                \ })
    " call deoplete#custom#option('num_processes', 0)

    " call deoplete#custom#option('profile', v:true)
    " call deoplete#enable_logging('DEBUG', 'deoplete.log')
    " call deoplete#custom#source('clang', 'debug_enabled', 1)

    call deoplete#enable()
endfunction

if g:feat_enable_lsp == 1
    if te#env#IsNvim() >= 0.5
        Plug 'deoplete-plugins/deoplete-lsp', {'on': []}
        call extend(g:complete_plugin.name, ['deoplete-lsp'])
    else
        Plug 'lighttiger2505/deoplete-vim-lsp', {'on': []}
        call extend(g:complete_plugin.name, ['deoplete-vim-lsp'])
    endif
endif



let g:complete_plugin.enable_func=function('<SID>config_deoplete')
