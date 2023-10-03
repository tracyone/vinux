if g:git_plugin_name.cur_val ==# 'gina.vim' && te#env#SupportAsync()
    execute 'source '.$VIMFILES.'/rc/gina.vim'
else
    "fallback option
    let g:git_plugin_name.cur_val = 'vim-fugitive'
    execute 'source '.$VIMFILES.'/rc/fugitive.vim'
endif
if g:feat_enable_basic == 1
    if g:file_explorer_plugin.cur_val == 'nerdtree'
       Plug 'Xuyuanp/nerdtree-git-plugin' 
       if g:enable_powerline_fonts.cur_val == 'on'
           let g:NERDTreeGitStatusUseNerdFonts = 1
       else
           let g:NERDTreeGitStatusUseNerdFonts = 0
       endif
       let g:NERDTreeGitStatusShowClean = 1
    elseif g:file_explorer_plugin.cur_val == 'defx.nvim'
        Plug 'kristijanhusak/defx-git'
    endif
endif

nnoremap gho :call te#git#browse_file(1)<cr>
xmap gho :<c-u>call te#git#browse_file(3)<cr>

nnoremap ghc :call te#git#browse_file(0)<cr>
xmap ghc :<c-u>call te#git#browse_file(2)<cr>

nnoremap  <silent><Leader>gl :call te#git#show_log(".")<cr>
nnoremap  <silent><Leader>gL :call te#git#show_log(".", "--all")<cr>
Plug 'rhysd/conflict-marker.vim'
if te#env#SupportFeature('signs')
    Plug 'airblade/vim-gitgutter', { 'on': [] }
    call te#feat#register_vim_enter_setting2(['GitGutterEnable'], 
                \ ['vim-gitgutter'])
endif
if te#env#SupportAsync()
    Plug 'rhysd/git-messenger.vim',{'on': '<Plug>(git-messenger)'}
    nmap  <silent><Leader>gn <Plug>(git-messenger)
    let g:git_messenger_no_default_mappings=v:true
endif
if te#env#IsNvim() > 0
    Plug 'nvim-lua/plenary.nvim' 
    Plug 'petertriho/cmp-git'
endif

" Git releate ---------------------{{{
" list git issue

nnoremap <silent><Leader>gi <Plug>(GitGutterPreviewHunk)
nnoremap <silent><Leader>ga <Plug>(GitGutterStageHunk)
nnoremap <silent><Leader>gu <Plug>(GitGutterUndoHunk)
" git merge
nnoremap  <silent><Leader>gm :call te#git#git_merge()<cr>
" arhcive vim config.
nnoremap  <silent><leader>gA :call te#git#archive_my_vim_cfg($VIMFILES,'vim_config')<cr>
" archive current git repo with default name
nnoremap  <silent><leader>gC :call te#git#archive_my_vim_cfg('.','')<cr>
" git push origin master
nnoremap  <silent><Leader>gp :call te#git#GitPush("heads")<cr>
" git push to gerrit
nnoremap  <silent><Leader>gg :call te#git#GitPush("for")<cr>
" git fetch all
nnoremap  <silent><Leader>gf :call te#utils#run_command('git fetch --all')<cr>
"}}}
