
if !te#env#check_requirement()
    Plug 'tpope/vim-fugitive', {'tag': 'v2.2'}
    nnoremap  <silent><F3> :silent! only<cr>:Gstatus<cr>
    nnoremap  <silent><Leader>gs :silent! only<cr>:Gstatus<cr>
else
    if te#env#IsNvim() || has('patch-8.2.3141')
        Plug 'tpope/vim-fugitive', {'dir': g:vinux_plugin_dir.cur_val.'/vim-fugitive-latest/'}
    else
        Plug 'tpope/vim-fugitive', {'tag': 'v3.2'}
    endif
    " Open git status window
    nnoremap  <silent><F3> :silent! only<cr>:G<cr>:call feedkeys(']]')<cr>
    nnoremap  <silent><Leader>gs :silent! only<cr>:G<cr>:call feedkeys(']]')<cr>
endif
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }
let g:fugitive_no_maps=0
nnoremap  <silent><Leader>sb :Twiggy<cr>
" Open git log( browser mode)
" Open git log(file mode)
nnoremap  <silent><Leader>gL :Gitv! --all<cr>
" Open git log(file mode)
vnoremap  <silent><leader>gL :Gitv! --all<cr>
" Open git blame windows
nnoremap  <silent><Leader>gb :Gblame<cr>
" git diff current file (vimdiff)
nnoremap  <silent><Leader>gd :Gdiff<cr>
" git cd
nnoremap  <silent><Leader>gc :Gcd<cr>:call te#utils#EchoWarning(getcwd())<cr>
" git config -e
nnoremap  <silent><Leader>ge :Gcd<cr>:sp .git/config<cr>
" Open github url
nnoremap  <silent><Leader>gh :call te#git#git_browse()<cr>
