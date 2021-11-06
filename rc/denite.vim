scriptencoding utf-8

if !te#env#SupportPy3() ||  !te#env#SupportAsync()
    call te#utils#EchoWarning('denite.nvim require python3 and async api support!', 1)
    let g:fuzzysearcher_plugin_name.cur_val='ctrlp'
    finish
endif

"{{{ denite setting function
function! s:denite_nvim_setting() abort

    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
        nnoremap <silent><buffer><expr> <CR>
                    \ denite#do_map('do_action')
        nnoremap <silent><buffer><expr> d
                    \ denite#do_map('do_action', 'delete')
        nnoremap <silent><buffer><expr> <c-t>
                    \ denite#do_map('do_action', 'tabopen')
        nnoremap <silent><buffer><expr> <c-v>
                    \ denite#do_map('do_action', 'vsplit')
        nnoremap <silent><buffer><expr> <c-x>
                    \ denite#do_map('do_action', 'split')
        nnoremap <silent><buffer><expr> p
                    \ denite#do_map('do_action', 'preview')
        nnoremap <silent><buffer><expr> q
                    \ denite#do_map('quit')
        nnoremap <silent><buffer><expr> i
                    \ denite#do_map('open_filter_buffer')
        nnoremap <silent><buffer><expr> V
                    \ denite#do_map('toggle_select').'j'
    endfunction


    autocmd FileType denite-filter call s:denite_filter_my_settings()
    function! s:denite_filter_my_settings() abort
        imap <silent><buffer> <tab> <Plug>(denite_filter_quit)
        inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
        inoremap <silent><buffer><expr> <c-t>
                    \ denite#do_map('do_action', 'tabopen')
        inoremap <silent><buffer><expr> <c-v>
                    \ denite#do_map('do_action', 'vsplit')
        inoremap <silent><buffer><expr> <c-x>
                    \ denite#do_map('do_action', 'split')
        inoremap <silent><buffer><expr> <esc>
                    \ denite#do_map('quit')
        inoremap <silent><buffer> <C-j>
                    \ <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
        inoremap <silent><buffer> <C-k>
                    \ <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
    endfunction


    " Change matchers.
    call denite#custom#source(
                \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])

    call denite#custom#source('tag', 'matchers', ['matcher/substring'])

    call denite#custom#source('file/old', 'converters',
                \ ['converter/relative_word'])
    " Change sorters.
    call denite#custom#source(
                \ 'file/rec', 'sorters', ['sorter/sublime'])

    if g:fuzzy_matcher_type.cur_val ==# 'cpsm'
        call denite#custom#source(
                    \ 'file/rec', 'matchers', ['matcher/cpsm'])
    endif


    " Ag command on grep source
    if te#env#Executable('ag')
        call denite#custom#var('grep', 'command', ['ag'])
        call denite#custom#var('grep', 'default_opts',
                    \ ['-i', '--vimgrep'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
        call denite#custom#var('file/rec', 'command',
                    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    endif

    if te#env#Executable('ack')
        " Ack command on grep source
        call denite#custom#var('grep', 'command', ['ack'])
        call denite#custom#var('grep', 'default_opts',
                    \ ['--ackrc', $HOME.'/.ackrc', '-H', '-i',
                    \  '--nopager', '--nocolor', '--nogroup', '--column'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--match'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
    endif

    if te#env#Executable('rg')
        " Ripgrep command on grep source
        call denite#custom#var('grep', 'command', ['rg'])
        call denite#custom#var('grep', 'default_opts',
                    \ ['-i', '--vimgrep', '--no-heading'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
        " For ripgrep
        " Note: It is slower than ag
        call denite#custom#var('file/rec', 'command',
                    \ ['rg', '--files', '--glob', '!.git'])
    endif


    if te#env#Executable('pt')
        " Pt command on grep source
        call denite#custom#var('grep', 'command', ['pt'])
        call denite#custom#var('grep', 'default_opts',
                    \ ['-i', '--nogroup', '--nocolor', '--smart-case'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
        " For Pt(the platinum searcher)
        " NOTE: It also supports windows.
        call denite#custom#var('file/rec', 'command',
                    \ ['pt', '--follow', '--nocolor', '--nogroup',
                    \  (has('win32') ? '-g:' : '-g='), ''])
    endif

    " Define alias
    call denite#custom#alias('source', 'file/rec/git', 'file/rec')
    call denite#custom#var('file/rec/git', 'command',
                \ ['git', 'ls-files', '-co', '--exclude-standard'])

    call denite#custom#alias('source', 'file/rec/py', 'file/rec')
    call denite#custom#var('file/rec/py', 'command',['scantree.py'])

    " Change ignore_globs
    call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
                \ [ '.git/', '.ropeproject/', '__pycache__/',
                \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

    let s:denite_options = {
                \ 'prompt' : '>',
                \ 'split': 'floating',
                \ 'start_filter': 1,
                \ 'auto_resize': 1,
                \ 'source_names': 'short',
                \ 'direction': 'botright',
                \ 'highlight_filter_background': 'CursorLine',
                \ 'highlight_matched_char': 'Type',
                \ }

    call denite#custom#option('default', s:denite_options)
endfunction
"}}}

Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/neomru.vim'
if g:fuzzy_matcher_type.cur_val ==# 'cpsm'
    Plug 'nixprime/cpsm', {'dir': g:vinux_plugin_dir.cur_val.'/cpsm_py3/',
                \ 'do':'PY3=ON ./install.sh'}
endif

"keymapping for denite
nnoremap  <silent><c-p> :Denite file/rec<cr>
nnoremap  <silent><Leader><Leader> :Denite file/rec<cr>
nnoremap  <silent><c-j> :Denite buffer<cr>
nnoremap  <silent><c-l> :Denite file_mru<cr>
nnoremap  <silent><c-k> :Denite outline<cr>
nnoremap  <silent><Leader>pc :Denite colorscheme -post-action=open<cr>
nnoremap  <silent><Leader>ff :Denite file<cr>
"mru
nnoremap  <silent><Leader>pm :Denite file_mru<cr>
"file
nnoremap  <silent><Leader>pp :Denite file/rec<cr>
"function
nnoremap  <silent><Leader>pp :Denite outline<cr>
"vim help
nnoremap  <silent><Leader>ph :Denite help<cr>
"command history
nnoremap  <silent><Leader>qc :Denite command_history<cr>
"fly on grep
nnoremap  <silent><Leader>pf :call denite#start([{'name': 'grep', 'args': ['', '', '!']}])<cr>


call te#feat#register_vim_enter_setting(function('<SID>denite_nvim_setting'))
