setlocal colorcolumn=
nnoremap <buffer> q :q<cr>
nnoremap <buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
nnoremap <buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
nnoremap <buffer> <cr> <c-]>
nnoremap <buffer> <bs> <c-T>

function! s:help_tag(prev)
  call search('|\S\+|', a:prev.'W')
endfunction

nnoremap <silent> <plug>(help-next-tag)
      \ :call <sid>help_tag('')<cr>
nnoremap <silent> <plug>(help-prev-tag)
      \ :call <sid>help_tag('b')<cr>

nmap <buffer> ]g <Plug>(help-next-tag)
nmap <buffer> [g <Plug>(help-prev-tag)
