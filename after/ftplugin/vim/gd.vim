function! s:_runtime_globpath(file)
  return split(globpath(escape(&runtimepath, ' '), a:file), "\n")
endfunction

function! s:_is_autoload_name(name)
  return matchstr(a:name, '\(\k\+#\)\+\k\+') == a:name
endfunction

function! s:_cursor_on_function_definition(name)
  return search('fu\%[nction]!\?\s\+\%['.a:name.']\%#', 'n') != 0
endfunction

function! s:_get_file_path_from_autoload_name(name)
  return 'autoload/'.fnamemodify(substitute(a:name, '#', '/', 'g'), ':h').'.vim'
endfunction

function! s:goto_definition(name)
  if s:_is_autoload_name(a:name)
    if s:_cursor_on_function_definition(a:name)
      return ''
    endif

    let path = s:_get_file_path_from_autoload_name(a:name)
    let real_path = get(s:_runtime_globpath(path), 0)

    if real_path =~ expand('%:p')
      normal! m'
      return 'call search(''fu\%[nction]!\?\s\+\zs'.a:name.''')'
    else
      return 'edit! +call\ search(''fu\\%[nction]!\\?\\s\\+\\zs'.a:name.''') '.real_path
    endif
  endif

  return 'normal! gd'
endfunction

" XXX: tpope/vim-scriptease remove ':' from iskeyword
" function! s:grab_cword()
"   let isk = &iskeyword
"   try
"     set iskeyword+=:
"     return expand('<cword>')
"   finally
"     let &iskeyword = isk
"   endtry
" endfunction

nnoremap <silent> <buffer> gd
      \ :execute <SID>goto_definition(expand("<cword>"))<cr>
