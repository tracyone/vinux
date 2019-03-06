"https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
if te#env#IsTmux()
    Plug 'ncm2/ncm2-tmux'
endif
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-github', {'for': ['markdown', 'rst', 'gitcommit']}
Plug 'filipekiss/ncm2-look.vim'
Plug 'ncm2/ncm2-vim', { 'for': ['vim']}
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-tagprefix'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
Plug 'fgrsnau/ncm2-otherbuf', {'branch': 'ncm2'}
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'ncm2/ncm2-vim-lsp'
Plug 'ncm2/ncm2-html-subscope',{'for': ['html', 'jsp', 'htmldjango']}
Plug 'ncm2/ncm2-markdown-subscope', {'for': 'markdown'}
Plug 'ncm2/ncm2-cssomni', {'for': ['css']}
Plug 'othree/jspc.vim', {'for': 'javascript'}

set shortmess+=c
if !te#env#IsNvim()
    Plug 'roxma/vim-hug-neovim-rpc', { 'do':'pip3 install --user pynvim'}
else
    Plug 'ncm2/float-preview.nvim'
endif

function! Ncm2_source_register()
    call ncm2#register_source({
                \ 'name' : 'css',
                \ 'priority': 9, 
                \ 'subscope_enable': 1,
                \ 'scope': ['css','scss'],
                \ 'mark': 'css',
                \ 'word_pattern': '[\w\-]+',
                \ 'complete_pattern': ':\s*',
                \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
                \ })
endfunction

autocmd misc_group InsertEnter * call ncm2#enable_for_buffer()
au misc_group TextChangedI * call ncm2#auto_trigger()

function! s:ncm2_setup()
    " enable ncm2 for all buffers

    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " wrap existing omnifunc
    " Note that omnifunc does not run in background and may probably block the
    " editor. If you don't want to be blocked by omnifunc too often, you could
    " add 180ms delay before the omni wrapper:
    "  'on_complete': ['ncm2#on_complete#delay', 180,
    "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    au User Ncm2Plugin call Ncm2_source_register()
    if te#env#IsMac()
        let g:ncm2_pyclang#library_path='/Library/Developer/CommandLineTools/usr/lib'
    elseif te#env#IsUnix()
        let g:ncm2_pyclang#library_path='/usr/local/lib'
    else
        let g:ncm2_pyclang#library_path='c:/LLVM/bin'
    endif
    let g:ncm2_pyclang#args_file_path = ['.clang_complete']
endfunction

if executable('clangd')
    au misc_group User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd']},
                \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                \ })
else
    Plug 'ncm2/ncm2-pyclang', { 'for': ['c', 'cpp']}
endif
if executable('pyls')
    " pip install python-language-server
    au misc_group User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ })
else
    Plug 'ncm2/ncm2-jedi', { 'for': ['python'], 'do': 'pip3 install --user jedi'}
endif

if executable('typescript-language-server')
    au misc_group User lsp_setup call lsp#register_server({
                \ 'name': 'javascript support using typescript-language-server',
                \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
                \ 'whitelist': ['javascript', 'javascript.jsx']
                \ })
else
    Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
endif
let g:complete_plugin.enable_func=function('<SID>ncm2_setup')

"go get -u golang.org/x/tools/cmd/golsp
"go get -u github.com/sourcegraph/go-langserver
if executable('golsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'golsp',
        \ 'cmd': {server_info->['golsp', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
else
    Plug 'ncm2/ncm2-go', {'for': ['go']}
endif
