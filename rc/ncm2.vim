"https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2'
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
if g:feat_enable_lsp == 1 && te#env#IsNvim() < 0.5
    Plug 'ncm2/ncm2-vim-lsp'
endif
Plug 'ncm2/ncm2-html-subscope',{'for': ['html', 'jsp', 'htmldjango']}
Plug 'ncm2/ncm2-markdown-subscope', {'for': 'markdown'}
Plug 'ncm2/ncm2-cssomni', {'for': ['css']}
Plug 'othree/jspc.vim', {'for': 'javascript'}

set shortmess+=c
if te#env#IsNvim() != 0
    Plug 'ncm2/float-preview.nvim'
endif

function! Ncm2_enable_buffer() abort
    let l:black_list_ft = ['denite-filter']
    for l:item in l:black_list_ft
        if &filetype ==# l:item
            call ncm2#disable_for_buffer()
        else
            call ncm2#enable_for_buffer()
        endif
    endfor
endfunction

autocmd misc_group InsertEnter *  call Ncm2_enable_buffer()
au misc_group TextChangedI * call ncm2#auto_trigger()

function! s:ncm2_setup()
    " enable ncm2 for all buffers

    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt+=noinsert,menuone,noselect
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
    au User Ncm2Plugin call ncm2#register_source({
                \ 'name' : 'css',
                \ 'priority': 9, 
                \ 'subscope_enable': 1,
                \ 'scope': ['css','scss'],
                \ 'mark': 'css',
                \ 'word_pattern': '[\w\-]+',
                \ 'complete_pattern': ':\s*',
                \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
                \ })
    if te#env#IsMac()
        let g:ncm2_pyclang#library_path='/Library/Developer/CommandLineTools/usr/lib'
    elseif te#env#IsUnix()
        let g:ncm2_pyclang#library_path='/usr/local/lib'
    else
        let g:ncm2_pyclang#library_path='c:/LLVM/bin'
    endif
    let g:ncm2_pyclang#args_file_path = ['.clang_complete']
endfunction

if !executable('clangd')
    Plug 'ncm2/ncm2-pyclang', { 'for': ['c', 'cpp']}
endif
if !executable('pyls')
    Plug 'ncm2/ncm2-jedi', { 'for': ['python'], 'do': 'pip3 install --user jedi'}
endif

if !executable('typescript-language-server')
    Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
endif
let g:complete_plugin.enable_func=function('<SID>ncm2_setup')

"go get -u golang.org/x/tools/cmd/golsp
"go get -u github.com/sourcegraph/go-langserver
if !executable('golsp')
    Plug 'ncm2/ncm2-go', {'for': ['go']}
endif
