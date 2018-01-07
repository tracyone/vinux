
augroup misc_group
    autocmd!
    autocmd CmdwinEnter * set ft= | noremap <buffer> q :q<cr> | nmap <buffer><silent> <cr> <Enter>
    autocmd BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  
    autocmd VimResized * wincmd = 
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ exe "normal! g'\"" |
                \ endif "jump to last position last open in vim
    autocmd VimEnter * call te#feat#run_vim_enter_setting()
augroup END

augroup lazy_load_group
    autocmd!
    autocmd InsertEnter * call te#feat#vim_plug_insert_enter()
                \| autocmd! lazy_load_group
augroup END

augroup filetype_group
    autocmd!
    autocmd BufRead,BufNewFile *.vt setlocal filetype=verilog
    "automatic recognition bld file as javascript 
    autocmd BufRead,BufNewFile *.bld setlocal filetype=javascript
    "automatic recognition xdc file as javascript
    autocmd BufRead,BufNewFile *.xdc setlocal filetype=javascript
    autocmd BufRead,BufNewFile *.mk setlocal filetype=make
    autocmd BufRead,BufNewFile *.make setlocal filetype=make
    autocmd BufRead,BufNewFile *.veo setlocal filetype=verilog
    autocmd BufRead,BufNewFile *.h setlocal filetype=c
    autocmd BufRead,BufNewFile * let $CurBufferDir=expand('%:p:h')
    autocmd BufRead,BufNewFile *.hex,*.out,*.o,*.a Vinarise
    autocmd BufRead,BufNewFile *.fex setlocal filetype=dosini

    autocmd FileType qf noremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR> 
                \ | noremap <buffer> <c-x> <C-w><Enter><C-w>K
                \ | nnoremap <buffer> q :ccl<cr>:lcl<cr>
                \ | nnoremap <buffer> o <CR><C-w>p
                \ | nnoremap <buffer> <c-j> <CR><C-w>p
                \ | nnoremap <buffer> <c-t> <C-w><CR><C-w>T
                \ | nnoremap <buffer> <c-v> <C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p
    " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
    autocmd FileType qfreplace setlocal nofoldenable | nmap <buffer> q :bdelete<cr>
    autocmd FileType gitcommit setlocal nofoldenable cursorline
    autocmd FileType vimcalc,man setlocal nonu nornu | imap <buffer> <c-d> :q<cr>
    autocmd FileType vim-plug nnoremap <buffer> <silent> H :call te#plug#open_doc()<cr> 
                \ | nnoremap <buffer> <silent> gx :call te#plug#browse_plugin_url()<cr>
                \ | nnoremap <buffer> <silent> <c-t> :call te#plug#open_plugin_dir()<cr>
                \ | call te#plug#extra_key()
augroup END
if te#env#IsNvim()
    autocmd misc_group TermOpen * setlocal nonu signcolumn=no | :startinsert
    "auto close terminal buffer
    autocmd misc_group TermClose * exe expand('<abuf>').'bd!'
    if exists('+winhighlight')
      autocmd BufEnter,FocusGained,TermClose * if te#autocmds#should_colorcolumn() | set winhighlight= | endif
      autocmd FocusLost,WinLeave * if te#autocmds#should_colorcolumn() | set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn | endif
    endif
else
    if te#env#IsMacVim()
        autocmd misc_group FocusGained * :redraw!
    endif
endif
if get(g:, 'feat_enable_basic') && te#env#SupportAsync()
    autocmd filetype_group BufWritePost,BufEnter *.php,*.sh,*.js Neomake
endif



