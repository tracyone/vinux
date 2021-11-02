call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#reg#init()',
      \ 'accept': 'te#ctrlp#reg#accept',
      \ 'lname': 'register',
      \ 'sname': 'reg',
      \ 'type': 'line',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = []
function! te#ctrlp#reg#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! te#ctrlp#reg#id() abort
    return s:id
endfunction

function! te#ctrlp#reg#accept(mode, str) abort
    call ctrlp#exit()
    let l:pos = stridx(a:str, ':')
    if !l:pos
        execute "normal! \"\"p"
    else
        let l:str = a:str[0:pos-1]
        execute "normal! \"".l:str."p"
    endif
endfunction

function! te#ctrlp#reg#start() abort
    let s:text = te#utils#get_reg()
    call ctrlp#init(te#ctrlp#reg#id()) 
endfunction
