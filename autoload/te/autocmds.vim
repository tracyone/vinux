let g:WindColorColumnBlacklist = ['diff', 'fugitiveblame', 'nerdtree', 'qf', 'leaderf']


"filetype that do not need to color
function! te#autocmds#should_colorcolumn() abort
  return index(g:WindColorColumnBlacklist, &filetype) == -1
endfunction

"Put all things that you want to be triggered by DirChanged
function! te#autocmds#dir_changed() abort
    "add cscope database if exist
    if te#env#SupportCscope()
        call te#pg#add_cscope_out(getcwd())
    endif
    "show current directory
    "call te#utils#EchoWarning(getcwd(), 'info')
endfunction

function! te#autocmds#file_type() abort
    let $CurBufferDir=expand('%:p:h')
    if g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocCheckExtensions()
    endif
endfunction
