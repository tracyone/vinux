let g:WindColorColumnBlacklist = ['diff', 'fugitiveblame', 'nerdtree', 'qf', 'leaderf']


"filetype that do not need to color
function! te#autocmds#should_colorcolumn() abort
  return index(g:WindColorColumnBlacklist, &filetype) == -1
endfunction

"Put all things that you want to be triggered by DirChanged
function! te#autocmds#dir_changed() abort
    "add cscope database if exist
    if te#env#SupportCscope()
        call te#pg#add_cscope_out(1)
    endif
    "show current directory
    call te#utils#EchoWarning(getcwd(), 'info')
endfunction
