let g:WindColorColumnBlacklist = ['diff', 'fugitiveblame', 'nerdtree', 'qf', 'leaderf']


"filetype that do not need to color
function! te#autocmds#should_colorcolumn() abort
  return index(g:WindColorColumnBlacklist, &filetype) == -1
endfunction
