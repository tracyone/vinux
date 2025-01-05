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
    if v:version < 800
       if exists('s:current_dir') && s:current_dir != getcwd()
           call te#autocmds#dir_changed()
       endif 
    endif
    let s:current_dir=getcwd()
    if g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocCheckExtensions()
    endif
    if exists('g:vinux_project')
        call te#project#set_indent_options(g:vinux_coding_style.cur_val)
    endif
endfunction
