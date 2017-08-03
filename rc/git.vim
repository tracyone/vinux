Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'jaxbot/github-issues.vim', { 'on': 'Gissue' }
Plug 'rhysd/github-complete.vim'
Plug 'airblade/vim-gitgutter'

" Git releate ---------------------{{{
let g:fugitive_no_maps=0
nnoremap <F3> :Gstatus<cr>
" Open git status window
nmap <Leader>gs :Gstatus<cr>gg<C-n>
" Open github url
nnoremap <Leader>gh :Gbrowse<cr>
" Open git log( browser mode)
nnoremap <Leader>gl :Gitv --all<cr>
" Open git log(file mode)
nnoremap <Leader>gL :Gitv! --all<cr>
" Open git log(file mode)
vnoremap <leader>gL :Gitv! --all<cr>
" Open git blame windows
nnoremap <Leader>gb :Gblame<cr>
" git diff current file (vimdiff)
nnoremap <Leader>gd :Gdiff<cr>
" list git issue
nnoremap <Leader>gi :silent! Gissue<cr>
" create new github issue
nnoremap <Leader>ga :silent! Giadd<cr>
" git merge
nnoremap <Leader>gm :call te#git#git_merge()<cr>
" arhcive vim config.
nnoremap <leader>gA :call te#git#archive_my_vim_cfg($VIMFILES,'vim_config')<cr>
" archive current git repo with default name
nnoremap <leader>gC :call te#git#archive_my_vim_cfg('.','')<cr>
" git cd
nnoremap <Leader>gc :Gcd<cr>:call te#utils#EchoWarning(getcwd())<cr>
let g:gissues_lazy_load = 1
let g:gissues_async_omni = 1
if filereadable($VIMFILES.'/.github_token')
    let g:github_access_token = readfile($VIMFILES.'/.github_token', '')[0]
endif
" git push origin master
nnoremap <Leader>gp :call te#git#GitPush("heads")<cr>
" git push to gerrit
nnoremap <Leader>gg :call te#git#GitPush("for")<cr>
" git fetch all
nnoremap <Leader>gf :call te#utils#run_command('git fetch --all')<cr>
"}}}
