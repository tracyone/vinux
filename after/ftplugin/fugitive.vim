nnoremap <silent><buffer> <c-n> :call feedkeys(']]')<cr>
nnoremap <silent><buffer> <c-p> :call feedkeys('[[')<cr>
nnoremap <silent><buffer> <c-t> :call feedkeys('O')<cr>
nnoremap <silent><buffer> t :call feedkeys('O')<cr>
nnoremap <silent><buffer> <c-x> :call feedkeys('o')<cr>
nnoremap <silent><buffer> q :call feedkeys('gq')<cr>
nnoremap <silent><buffer> U :call feedkeys('X')<cr>
xnoremap <silent><buffer> U :call feedkeys('X')<cr>
nnoremap <silent><buffer> cc :<C-U>Gcommit --signoff<CR>
nnoremap <silent><buffer> ce :<C-U>Gcommit --amend --no-edit --signoff<CR>
nnoremap <buffer> <silent> cw :<C-U>Gcommit --amend --only --signoff<CR>
nnoremap <buffer> <silent> cva :<C-U>Gcommit -v --amend --signoff<CR>
nnoremap <buffer> <silent> cvc :<C-U>Gcommit -v --signoff<CR>

