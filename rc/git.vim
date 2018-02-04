if g:git_plugin_name.cur_val ==# 'gina.vim' && te#env#SupportAsync()
    Plug 'lambdalisue/gina.vim'
    nnoremap <F3> :Gina status<cr>
    " Open git status window
    nnoremap <Leader>gs :Gina status<cr>
    " Open github url
    nnoremap <Leader>gh :Gina browse<cr>
    " Open git blame windows
    nnoremap <Leader>gb :Gina blame --use-author-instead :<cr>
    " show branch
    nnoremap <Leader>sb :Gina branch -a<cr>
    " show tag
    nnoremap <Leader>st :Gina tag<cr>
    " git diff current file
    nnoremap <Leader>gd :Gina compare :<cr>
    " git cd
    nnoremap <Leader>gc :Gina cd<cr>:call te#utils#EchoWarning(getcwd())<cr>

    function! StageNext(count) abort
        for i in range(a:count)
            call search('^\t.*','W')
        endfor
        return '.'
    endfunction

    function! StagePrevious(count) abort
        if line('.') == 1 && exists(':CtrlP') && get(g:, 'ctrl_p_map') =~? '^<c-p>$'
            return 'CtrlP '.fnameescape(s:repo().tree())
        else
            for i in range(a:count)
                call search('^\t.*','Wbe')
            endfor
            return '.'
        endif
    endfunction

    function s:gina_setting()
        call gina#custom#command#option('status', '--opener', &previewheight . 'split')
        call gina#custom#command#option('commit', '--opener', &previewheight . 'split')
        call gina#custom#command#option('status', '--group', 'short')
        call gina#custom#command#option('commit', '--group', 'short')
        "log windows
        silent! call gina#custom#mapping#nmap(
                    \ 'log', 'yy',
                    \ ':call gina#action#call(''yank:rev'')<CR>',
                    \ {'noremap': 1, 'silent': 0},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'log', '<c-n>',
                    \ 'j:call gina#action#call(''show:preview'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'log', '<c-p>',
                    \ 'k:call gina#action#call(''show:preview'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'log', '<cr>',
                    \ ':call gina#action#call(''show:preview'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'log', '<c-t>',
                    \ ':call gina#action#call(''show:tab'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'log', '<tab>',
                    \ '<c-w>w',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        "blame windows
        silent! call gina#custom#mapping#nmap(
                    \ 'blame', '<cr>',
                    \ ':call gina#action#call(''show:commit:tab'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        "branch windows
        silent! call gina#custom#mapping#nmap(
                    \ 'branch', 'cc',
                    \ ':call gina#action#call(''checkout:track'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        "status windows
        let g:gina#command#status#use_default_mappings=0
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'cc',
                    \ ':<C-u>Gina commit<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', '<cr>',
                    \ ':call gina#action#call(''edit'')<CR>',
                    \ {'noremap': 1, 'silent': 0},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'yy',
                    \ ':call gina#action#call(''yank:path'')<CR>',
                    \ {'noremap': 1, 'silent': 0},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', '-',
                    \ ':call gina#action#call(''index:toggle'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'e',
                    \ ':call gina#action#call(''diff'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#vmap(
                    \ 'status', '-',
                    \ ':call gina#action#call(''index:toggle'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', '<c-n>',
                    \ ':<C-U>execute StageNext(v:count1)<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', '<tab>',
                    \ ':<C-U>execute StageNext(v:count1)<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', '<c-p>',
                    \ ':<C-U>execute StagePrevious(v:count1)<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'ca',
                    \ ':<C-u>Gina commit --amend<CR>:0<cr>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'commit', 'cc',
                    \ ':<C-u>Gina status<CR>:0<cr>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'U',
                    \ ':call gina#action#call(''index:discard'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'u',
                    \ ':call gina#action#call(''checkout'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#vmap(
                    \ 'status', 'u',
                    \ ':call gina#action#call(''checkout'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'd',
                    \ ':call gina#action#call(''patch'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'status', 'D',
                    \ ':call gina#action#call(''compare'')<CR>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ '/.*', 'q',
                    \ ':call te#utils#quit_win(0)<cr>',
                    \ {'noremap': 1, 'silent': 1},
                    \)
        "let g:gina#command#status#use_default_mappings=0
        silent! call gina#custom#mapping#nmap(
                    \ 'blame', 'j',
                    \ 'j<Plug>(gina-blame-echo)'
                    \)
        silent! call gina#custom#mapping#nmap(
                    \ 'blame', 'k',
                    \ 'k<Plug>(gina-blame-echo)'
                    \)
    endfunction

    call te#feat#register_vim_enter_setting(function('<SID>gina_setting'))
else
    "fallback option
    let g:git_plugin_name.cur_val = 'vim-fugitive'
    Plug 'tpope/vim-fugitive'
    Plug 'gregsexton/gitv', { 'on': 'Gitv' }
    let g:fugitive_no_maps=0
    nnoremap <F3> :only<cr>:Gstatus<cr>
    " Open git status window
    nnoremap <Leader>gs :only<cr>:Gstatus<cr>gg<C-n>
    " Open git log( browser mode)
    " Open git log(file mode)
    nnoremap <Leader>gL :Gitv! --all<cr>
    " Open git log(file mode)
    vnoremap <leader>gL :Gitv! --all<cr>
    " Open git blame windows
    nnoremap <Leader>gb :Gblame<cr>
    " git diff current file (vimdiff)
    nnoremap <Leader>gd :Gdiff<cr>
    " git cd
    nnoremap <Leader>gc :Gcd<cr>:call te#utils#EchoWarning(getcwd())<cr>
    " Open github url
    nnoremap <Leader>gh :call te#git#git_browse()<cr>
endif
nnoremap <Leader>gl :call te#git#show_log(".")<cr>
if te#env#SupportPy2()
    Plug 'jaxbot/github-issues.vim', { 'on': 'Gissue' }
endif
Plug 'rhysd/github-complete.vim',{'for': ['gitcommit', 'markdown']}
if te#env#SupportFeature('signs')
    Plug 'airblade/vim-gitgutter', { 'on': [] }
    call te#feat#register_vim_plug_insert_setting(['GitGutterEnable'], 
                \ ['vim-gitgutter'])
endif

" Git releate ---------------------{{{
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
" git config -e
nnoremap <Leader>ge :sp .git/config<cr>
"}}}
