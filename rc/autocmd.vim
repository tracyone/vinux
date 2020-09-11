
augroup misc_group
    autocmd!
    autocmd CmdwinEnter * set ft= | noremap <buffer> q :q<cr> | nmap <buffer><silent> <cr> <Enter>
    autocmd BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  
    autocmd VimResized * wincmd = 
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ exe "normal! g'\"" |
                \ endif "jump to last position last open in vim
    autocmd VimEnter * call te#feat#run_vim_enter_setting()
    autocmd FileChangedRO * setlocal noreadonly | call te#utils#EchoWarning('Changing readonly file ...')
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
    autocmd BufRead,BufNewFile *.hex,*.out,*.o,*.a,*.bin Vinarise
    autocmd BufRead,BufNewFile *.fex setlocal filetype=dosini

    autocmd FileType crontab setlocal nobackup nowritebackup
    autocmd FileType fugitiveblame nnoremap <silent><buffer> q :call feedkeys('gq')<cr>

    autocmd FileType gitcommit setlocal nofoldenable cursorline
    autocmd FileType qfreplace,vimcalc,man setlocal nonu nornu nofoldenable | imap <buffer> <c-d> :q<cr>
                \ | nmap <buffer> q :bdelete<cr> | setlocal matchpairs-=<:>
    autocmd FileType vim-plug nnoremap <buffer> <silent> H :call te#plug#open_doc()<cr> 
                \ | nnoremap <buffer> <silent> <leader>ol :call te#plug#browse_plugin_url()<cr>
                \ | nnoremap <buffer> <silent> <c-t> :call te#plug#open_plugin_dir(1)<cr>
                \ | nnoremap <buffer> <silent> D :call te#plug#show_log()<cr>
                \ | call te#plug#extra_key()
augroup END
if te#env#IsNvim()
    autocmd misc_group TermOpen * setlocal nonu nornu signcolumn=no | :startinsert
    "auto close terminal buffer
    autocmd misc_group TermClose * exe expand('<abuf>').'bd!'
    autocmd misc_group  FileType fzf tnoremap <buffer> <c-v> <c-v>
    autocmd misc_group User Startified setlocal buflisted
else
    autocmd misc_group  FileType fzf tnoremap <buffer> <c-z> <tab><c-k>
    if te#env#IsMacVim()
        autocmd misc_group FocusGained * :redraw!
    endif
endif



