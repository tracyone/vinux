"ctrlp history
"vim command history and search history
"author:tracyone@live.cn

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#history#init()',
      \ 'accept': 'te#ctrlp#history#accept',
      \ 'lname': 'History',
      \ 'sname': 'His',
      \ 'type': 'line',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = []
let s:his_type = ''
function! te#ctrlp#history#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! te#ctrlp#history#accept(mode, str) abort
    call ctrlp#exit()
    try
        execute s:his_type.a:str
    catch
        call te#utils#EchoWarning('Fail to execute '.s:his_type.a:str)
    endtry
endfunction

function! te#ctrlp#history#id() abort
  return s:id
endfunction

function! s:history_source(type)
  let max  = histnr(a:type)
  let fmt  = ' %'.len(string(max)).'d '
  let list = filter(map(range(1, max), 'histget(a:type, - v:val)'), '!empty(v:val)')
  return list
endfunction

function! te#ctrlp#history#start(arg) abort
    if type(a:arg) == g:t_string
        let s:text = s:history_source(a:arg)
        let s:his_type = a:arg
    endif
    call ctrlp#init(te#ctrlp#history#id()) 
endfunction
