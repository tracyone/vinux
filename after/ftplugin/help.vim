setlocal colorcolumn=
nnoremap <buffer> q :q<cr>

function! s:help_tag(prev)
  call search('|\S\+|', a:prev.'W')
endfunction

nnoremap <silent> <plug>(help-next-tag)
      \ :call <sid>help_tag('')<cr>
nnoremap <silent> <plug>(help-prev-tag)
      \ :call <sid>help_tag('b')<cr>

nmap <buffer> ]g <Plug>(help-next-tag)
nmap <buffer> [g <Plug>(help-prev-tag)
