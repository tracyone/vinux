
augroup misc_group
    autocmd!
    autocmd CmdwinEnter * set ft= | noremap <buffer> q :q<cr> | nmap <buffer><silent> <cr> <Enter>
    autocmd BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  
    autocmd VimResized * wincmd = 
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && line(".") == 1 |
                \ exe "normal! g'\"" |
                \ endif "jump to last position last open in vim
    if !te#env#SupportTimer()
        autocmd VimEnter * call te#feat#run_vim_enter_setting(0)
    endif
    autocmd FileChangedRO * setlocal noreadonly | call te#utils#EchoWarning('Changing readonly file ...')
    if g:complete_plugin_type.cur_val == 'asyncomplete.vim' && g:feat_enable_complete == 1
        autocmd InsertCharPre * call AsyncOpenCompleteMenu()
    endif
    if te#env#IsVim() >= 800 || te#env#IsNvim() > 0
        autocmd DirChanged * call te#autocmds#dir_changed()
    endif
    if g:enable_sexy_mode.cur_val != 0
        autocmd BufReadPre * call timer_start(300, function('te#tools#run_sexy_command'), {'repeat': 1})
    endif
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
    autocmd BufRead,BufNewFile *.veo setlocal filetype=verilog
    autocmd BufEnter * :call te#autocmds#file_type()
    autocmd BufRead,BufNewFile *.hex,*.out,*.o,*.a,*.bin Vinarise
    autocmd BufRead,BufNewFile *.fex setlocal filetype=dosini

    autocmd FileType crontab setlocal nobackup nowritebackup
    autocmd FileType fugitiveblame nnoremap <silent><buffer> q :call feedkeys('gq')<cr>
    autocmd FileType vinarise nmap <buffer><c-g> :call feedkeys("gG")<cr>

    autocmd FileType gitcommit setlocal nofoldenable cursorline
    autocmd FileType qfreplace,vimcalc setlocal nonu nornu nofoldenable | imap <buffer> <c-d> :q<cr>
                \ | nmap <buffer> q :bdelete<cr> | setlocal matchpairs-=<:>
    autocmd FileType vim-plug  call te#plug#extra_key()
augroup END
if te#env#IsNvim() != 0
    autocmd misc_group TermOpen * setlocal nonu nornu signcolumn=no | :startinsert
    "auto close terminal buffer
    autocmd misc_group  FileType fzf tnoremap <buffer> <c-v> <c-v>
    autocmd misc_group User Startified setlocal buflisted
else
    autocmd misc_group  FileType fzf tnoremap <buffer> <c-z> <tab><c-k> |
                \ tnoremap <buffer> <c-v> <c-v>
    if te#env#IsMacVim()
        autocmd misc_group FocusGained * :redraw!
    endif
endif



